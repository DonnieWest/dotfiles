{1 :mfussenegger/nvim-lint
 :event [:BufReadPost :BufNewFile]
 :config #(let [lint (require :lint)
                severity {:error vim.diagnostic.severity.ERROR
                          :warning vim.diagnostic.severity.WARN}]
            (local eslint-cache {})

            (fn resolve-eslint []
              (let [start (vim.fs.dirname (vim.api.nvim_buf_get_name 0))
                    cached (. eslint-cache start)]
                (if (not= cached nil)
                    (if cached cached nil)
                    (let [matches (vim.fs.find :node_modules/.bin/eslint
                                               {:path start
                                                :upward true
                                                :type :file})
                          global-eslint (vim.fn.exepath :eslint)
                          command (or (. matches 1)
                                      (and (not= global-eslint "")
                                           global-eslint))]
                      (tset eslint-cache start (or command false))
                      command))))

            (set lint.linters.lit_analyzer
                 {:cmd :node
                  :args [(or vim.g.lit_analyzer_script
                             (.. (vim.fn.stdpath :config)
                                 :/scripts/lit-analyzer.js))
                         (fn []
                           (vim.fn.fnamemodify (assert (vim.uv.fs_realpath (vim.fn.exepath :lit-analyzer))
                                                       "Could not resolve lit-analyzer")
                                               ":h"))]
                  :stdin false
                  :stream :stdout
                  :ignore_exitcode true
                  :parser (fn [output]
                            (let [diagnostics []]
                              (each [line (output:gmatch "[^\r\n]+")]
                                (let [(lnum col level message) (line:match "^%s*(%d+):(%d+)%s+(%a+)%s+(.+)$")]
                                  (when message
                                    (table.insert diagnostics
                                                  {:lnum (- (tonumber lnum) 1)
                                                   :end_lnum (- (tonumber lnum)
                                                                1)
                                                   :col (tonumber col)
                                                   :end_col (+ (tonumber col) 1)
                                                   :severity (. severity level)
                                                   : message
                                                   :source :lit-analyzer}))))
                              diagnostics))})
            (set lint.linters.eslint.cmd #(or (resolve-eslint) :eslint))
            (vim.api.nvim_create_autocmd [:BufWritePost]
                                         {:pattern [:*.fnl
                                                    :*.js
                                                    :*.jsx
                                                    :*.ts
                                                    :*.tsx]
                                          :callback (fn []
                                                      (let [names []]
                                                        (when (= vim.bo.filetype
                                                                 :fennel)
                                                          (table.insert names
                                                                        :fennel))
                                                        (when (vim.tbl_contains [:javascript
                                                                                 :javascriptreact
                                                                                 :typescript
                                                                                 :typescriptreact
                                                                                 :javascript.jsx
                                                                                 :typescript.tsx]
                                                                                vim.bo.filetype)
                                                          (when (resolve-eslint)
                                                            (table.insert names
                                                                          :eslint))
                                                          (when (> (vim.fn.executable :lit-analyzer)
                                                                   0)
                                                            (table.insert names
                                                                          :lit_analyzer)))
                                                        (when (> (length names)
                                                                 0)
                                                          (lint.try_lint names))))})
            (set lint.linters_by_ft
                 {:fennel [:fennel]
                  :javascript [:eslint :lit_analyzer]
                  :javascriptreact [:eslint :lit_analyzer]
                  :typescript [:eslint :lit_analyzer]
                  :typescriptreact [:eslint :lit_analyzer]
                  :javascript.jsx [:eslint :lit_analyzer]
                  :typescript.tsx [:eslint :lit_analyzer]}))}
