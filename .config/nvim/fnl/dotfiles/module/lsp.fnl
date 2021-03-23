(module dotfiles.module.core
        {require {nvim aniseed.nvim
                  mapping dotfiles.module.mapping
                  lsp lspconfig
                  lightbulb nvim-lightbulb
                  lsp-status lsp-status
                  lsp-code-action lsputil.codeAction
                  lsp-symbols lsputil.symbols
                  lsp-locations lsputil.locations}})

(defn on-attach [client bufnr]
      (lsp-status.on_attach client bufnr)
      (mapping.noremap :n :gd     "<cmd>lua vim.lsp.buf.declaration()<CR>")
      (mapping.noremap :n "<c-]>" "<cmd>lua vim.lsp.buf.definition()<CR>")
      (mapping.noremap :n :K      "<cmd>lua vim.lsp.buf.hover()<CR>")
      (mapping.noremap :n :gD     "<cmd>lua vim.lsp.buf.implementation()<CR>")
      (mapping.noremap :n :<c-k>  "<cmd>lua vim.lsp.buf.signature_help()<CR>")
      (mapping.noremap :n :1gD    "<cmd>lua vim.lsp.buf.type_definition()<CR>")
      (mapping.noremap :n :gr     "<cmd>lua vim.lsp.buf.references()<CR>")
      (mapping.noremap :n :g0     "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
      (mapping.noremap :n :gW     "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
      (mapping.noremap :n :ga     "<cmd>lua vim.lsp.buf.code_action()<CR>")
      (mapping.noremap :n :<Leader>r "<cmd>lua vim.lsp.buf.rename()<CR>")
      (nvim.ex.autocmd :CursorHold :<buffer> "lua vim.lsp.diagnostic.show_line_diagnostics()"))

(nvim.ex.autocmd :FileType :clojure "nnoremap <silent> <leader>fm    <cmd>lua vim.lsp.buf.formatting()<CR>")

; Configure LSP with kind labels
(local kind-labels-mt {:__index (fn [_ k]
                                  k)})
(local kind-labels {})
(setmetatable kind-labels kind-labels-mt)
(lsp-status.config {:kind_labels kind-labels :status_symbol ""})

(lsp-status.register_progress)

(tset vim.lsp.handlers :textDocument/codeAction
      lsp-code-action.code_action_handler)
(tset vim.lsp.handlers :textDocument/references
      lsp-locations.references_handler)
(tset vim.lsp.handlers :textDocument/definition
      lsp-locations.definition_handler)
(tset vim.lsp.handlers :textDocument/declaration
      lsp-locations.declaration_handler)
(tset vim.lsp.handlers :textDocument/typeDefinition
      lsp-locations.typeDefinition_handler)
(tset vim.lsp.handlers :textDocument/implementation
      lsp-locations.implementation_handler)
(tset vim.lsp.handlers :textDocument/documentSymbol
      lsp-symbols.document_handler)
(tset vim.lsp.handlers :workspace/symbol lsp-symbols.workspace_handler)
(tset vim.lsp.handlers :textDocument/publishDiagnostics
      (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
                    {:virtual_text false :signs true :update_in_insert false}))

(vim.cmd "autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()")
(vim.cmd "autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = \"Comment\" }")

(lsp.tsserver.setup {:on_attach on-attach})
(lsp.gopls.setup {:on_attach on-attach})
(lsp.tsserver.setup {:on_attach on-attach})
(lsp.gopls.setup {:on_attach on-attach})
(lsp.clojure_lsp.setup {:on_attach on-attach})
(lsp.jsonls.setup {:on_attach on-attach
                   :settings {:json {:schemas [{:description "TypeScript compiler configuration file"
                                                :fileMatch ["tsconfig.json"
                                                            ":tsconfig.*.json"]
                                                :url "http://json.schemastore.org/tsconfig"}
                                               {:description "NPM package.json"
                                                :fileMatch [ "package.json"]
                                                :url "http://json.schemastore.org/package"}
                                               {:description "Lerna config"
                                                :fileMatch [":lerna.json"]
                                                :url "http://json.schemastore.org/lerna"}
                                               {:description "Babel configuration"
                                                :fileMatch [".babelrc.json"
                                                            ".babelrc"
                                                            "babel.config.json"]
                                                :url "http://json.schemastore.org/lerna"}
                                               {:description "ESLint config"
                                                :fileMatch [".eslintrc.json"
                                                            ".eslintrc"]
                                                :url "http://json.schemastore.org/eslintrc"}
                                               {:description "Bucklescript config"
                                                :fileMatch [":bsconfig.json"]
                                                :url "https://bucklescript.github.io/bucklescript/docson/build-schema.json"}
                                               {:description "Prettier config"
                                                :fileMatch [".prettierrc"
                                                            ".prettierrc.json"
                                                            "prettier.config.json"]
                                                :url "http://json.schemastore.org/prettierrc"}]}
                              :jsonls {:textDocument {:completion {:completionItem {:snippetSupport true}}}}}})

(lsp.kotlin_language_server.setup {:cmd [:/home/igneo676/.config/nvim/plugged/kotlin-language-server/server/build/install/server/bin/kotlin-language-server]
                                   :log_level vim.lsp.protocol.MessageType.Log
                                   :root_dir (or (lsp.util.root_pattern :settings.gradle.kts)
                                                 (lsp.util.root_pattern :settings.gradle))
                                   :message_level vim.lsp.protocol.MessageType.Log
                                   :on_attach on-attach
                                   :settings {:kotlin {:compiler {:jvm {:target :1.8}}}}})

