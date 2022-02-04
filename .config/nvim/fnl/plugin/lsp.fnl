(module core.lsp {require {nvim aniseed.nvim
                           mapping mapping
                           cmp-lsp cmp_nvim_lsp
                           lsp lspconfig
                           schemastore schemastore
                           lightbulb nvim-lightbulb
                           lsp-code-action lsputil.codeAction
                           lsp-symbols lsputil.symbols
                           lsp-locations lsputil.locations}})

(var capabilities (vim.lsp.protocol.make_client_capabilities))
(set capabilities
     ((. (require :cmp_nvim_lsp) :update_capabilities) capabilities))

(defn on-attach [client bufnr]
      (mapping.noremap :n :gd "<cmd>lua vim.lsp.buf.declaration()<CR>")
      (mapping.noremap :n "<c-]>" "<cmd>lua vim.lsp.buf.definition()<CR>")
      (mapping.noremap :n :K "<cmd>lua vim.lsp.buf.hover()<CR>")
      (mapping.noremap :n :gD "<cmd>lua vim.lsp.buf.implementation()<CR>")
      (mapping.noremap :n :<c-k> "<cmd>lua vim.lsp.buf.signature_help()<CR>")
      (mapping.noremap :n :1gD "<cmd>lua vim.lsp.buf.type_definition()<CR>")
      (mapping.noremap :n :gr "<cmd>lua vim.lsp.buf.references()<CR>")
      (mapping.noremap :n :g0 "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
      (mapping.noremap :n :gW "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
      (mapping.noremap :n :ga "<cmd>lua vim.lsp.buf.code_action()<CR>")
      (mapping.noremap :n :<Leader>r "<cmd>lua vim.lsp.buf.rename()<CR>")
      (mapping.noremap :n :<F19> "<cmd>lua vim.lsp.buf.rename()<CR>")
      (nvim.ex.autocmd :CursorHold :<buffer> "lua vim.diagnostic.open_float()"))

(nvim.ex.autocmd :FileType :clojure
                 "nnoremap <silent> <leader>fm    <cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>")

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
(vim.cmd "autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost .rs,.ts,.js lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = \"Comment\" }")

(lsp.tsserver.setup {:on_attach on-attach
                     : capabilities
                     :init_options {:preferences {:allowIncompleteCompletions false
                                                  :hostInfo :neovim}}})

(lsp.gopls.setup {:on_attach on-attach : capabilities})
(lsp.clojure_lsp.setup {:on_attach on-attach : capabilities})
(lsp.jsonls.setup {:on_attach on-attach
                   : capabilities
                   :settings {:json {:schemas (schemastore.json.schemas)}
                              :jsonls {:textDocument {:completion {:completionItem {:snippetSupport true}}}}}})

(lsp.jdtls.setup {:on_attach on-attach : capabilities})
(lsp.tailwindcss.setup {:on_attach on-attach : capabilities})
(lsp.kotlin_language_server.setup {:cmd [:/home/donniew/.local/share/nvim/site/pack/packer/start/kotlin-language-server/server/build/install/server/bin/kotlin-language-server]
                                   :log_level vim.lsp.protocol.MessageType.Log
                                   :root_dir (or (lsp.util.root_pattern :settings.gradle.kts)
                                                 (lsp.util.root_pattern :settings.gradle))
                                   :message_level vim.lsp.protocol.MessageType.Log
                                   :on_attach on-attach
                                   : capabilities
                                   :settings {:kotlin {:compiler {:jvm {:target :1.8}}}}})

