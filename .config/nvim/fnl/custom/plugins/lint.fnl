{1 :mfussenegger/nvim-lint
 :config #(let [lint (require :lint)
                severity {:error vim.diagnostic.severity.ERROR
                          :warning vim.diagnostic.severity.WARN}]
            (set lint.linters.lit_analyzer
                 {:cmd :node
                  :args [(.. (vim.fn.stdpath :config) :/scripts/lit-analyzer.js)
                         (fn []
                           (vim.fn.fnamemodify (assert (vim.uv.fs_realpath
                                                       (vim.fn.exepath :lit-analyzer))
                                                      "Could not resolve lit-analyzer")
                                               ":h"))]
                  :stdin false
                  :stream :stdout
                  :ignore_exitcode true
                  :parser (fn [output]
                            (let [diagnostics []]
                              (each [line (output:gmatch "[^\r\n]+")]
                                (let [(lnum col level message)
                                      (line:match "^%s*(%d+):(%d+)%s+(%a+)%s+(.+)$")]
                                  (when message
                                    (table.insert diagnostics
                                                  {:lnum (- (tonumber lnum) 1)
                                                   :end_lnum (- (tonumber lnum) 1)
                                                   :col (tonumber col)
                                                   :end_col (+ (tonumber col) 1)
                                                   :severity (. severity level)
                                                   :message message
                                                   :source :lit-analyzer}))))
                              diagnostics))})
            (set lint.linters.eslint.cmd
                 (fn []
                   (let [start (vim.fs.dirname (vim.api.nvim_buf_get_name 0))
                         matches (vim.fs.find :node_modules/.bin/eslint
                                              {:path start
                                               :upward true
                                               :type :file})]
                     (or (. matches 1) :eslint))))
            (vim.api.nvim_create_autocmd [:BufWritePost]
                                         {:callback #(lint.try_lint)})
            (set lint.linters_by_ft
                 {:fennel [:fennel]
                  :javascript [:eslint :lit_analyzer]
                  :javascriptreact [:eslint :lit_analyzer]
                  :typescript [:eslint :lit_analyzer]
                  :typescriptreact [:eslint :lit_analyzer]
                  :javascript.jsx [:eslint :lit_analyzer]
                  :typescript.tsx [:eslint :lit_analyzer]}))}
