(module core.lsp {require {nvim aniseed.nvim
                           mapping mapping
                           cmp-lsp cmp_nvim_lsp
                           lsp lspconfig
                           schemastore schemastore
                           ts-utils nvim-lsp-ts-utils
                           virtualtypes virtualtypes
                           lightbulb nvim-lightbulb
                           document-color document-color
                           lsp-code-action lsputil.codeAction
                           lsp-symbols lsputil.symbols
                           lsp-locations lsputil.locations}})

(document-color.setup {:mode :background})

(def capabilities (cmp-lsp.default_capabilities))

(set capabilities.textDocument.colorProvider {:dynamicRegistration true})

(defn on-attach [client bufnr] (virtualtypes.on_attach client bufnr)
      (when client.server_capabilities.colorProvider
        (document-color.buf_attach bufnr))
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
      (mapping.noremap :n :grr "<cmd>lua vim.lsp.buf.rename()<CR>")
      (mapping.noremap :n :<F19> "<cmd>lua vim.lsp.buf.rename()<CR>")
      (nvim.ex.autocmd :CursorHold :<buffer>
                       "lua vim.diagnostic.open_float(nil, { focusable = false })"))

(nvim.ex.autocmd :FileType :clojure
                 "nnoremap <silent> <leader>fm    <cmd>lua vim.lsp.buf.format()<CR>")

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

(def- diagnostic-config {:virtual_text false
                         :signs true
                         :underline true
                         :update_in_insert true
                         :severity_sort true})

(tset vim.lsp.handlers :workspace/symbol lsp-symbols.workspace_handler)
(tset vim.lsp.handlers :textDocument/publishDiagnostics
      (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics diagnostic-config))

(vim.diagnostic.config diagnostic-config)

(vim.cmd "autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()")
(vim.cmd "autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost .rs,.ts,.js lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = \"Comment\" }")

(defn- filter [arr ___fn-__] (if (not= (type arr) :table)
                                 arr)
       (local filtered {})
       (each [k v (pairs arr)]
         (when (___fn-__ v k arr)
           (table.insert filtered v))) filtered)

(defn- filter-dts [value] (= (string.match value.uri :d.ts) nil))

(defn- definition-handler [err result method ...]
       (if (and (vim.tbl_islist result) (> (length result) 1))
           (vim.lsp.handlers.textDocument/definition err
                                                     ((filter result filter-dts))
                                                     method ...)
           (vim.lsp.handlers.textDocument/definition err result method ...)))

(defn ts-on-attach [client bufnr] (on-attach client bufnr)
      (ts-utils.setup {:debug false
                       :disable_commands false
                       :enable_import_on_completion false
                       :import_all_timeout 5000
                       :import_all_priorities {:same_file 1
                                               :local_files 2
                                               :buffer_content 3
                                               :buffers 4}
                       :import_all_scan_buffers 100
                       :import_all_select_source false
                       :always_organize_imports true
                       :filter_out_diagnostics_by_severity {}
                       :filter_out_diagnostics_by_code {}
                       :auto_inlay_hints true
                       :inlay_hints_highlight :Comment
                       :inlay_hints_priority 200
                       :inlay_hints_throttle 150
                       :inlay_hints_format {:Type {} :Parameter {} :Enum {}}
                       :update_imports_on_move false
                       :require_confirmation_on_move false
                       :watch_dir nil}) (ts-utils.setup_client client)
      (local opts {:silent true})
      (vim.api.nvim_buf_set_keymap bufnr :n :gs ":TSLspOrganize<CR>" opts)
      (vim.api.nvim_buf_set_keymap bufnr :n :gi ":TSLspImportAll<CR>" opts))

(lsp.tsserver.setup {:on_attach ts-on-attach
                     : capabilities
                     :handlers {:textDocument/definition definition-handler}
                     :init_options {:preferences {:allowIncompleteCompletions false
                                                  :includeInlayParameterNameHints :all
                                                  :includeInlayParameterNameHintsWhenArgumentMatchesName true
                                                  :includeInlayFunctionParameterTypeHints true
                                                  :includeInlayVariableTypeHints true
                                                  :includeInlayPropertyDeclarationTypeHints true
                                                  :includeInlayFunctionLikeReturnTypeHints true
                                                  :includeInlayEnumMemberValueHints true
                                                  :hostInfo :neovim}}})

(lsp.gopls.setup {:on_attach on-attach : capabilities})
(lsp.clojure_lsp.setup {:on_attach on-attach : capabilities})
(lsp.jsonls.setup {:on_attach on-attach
                   : capabilities
                   :settings {:json {:schemas (schemastore.json.schemas)}
                              :jsonls {:textDocument {:completion {:completionItem {:snippetSupport true}}}}}})

(lsp.jdtls.setup {:on_attach on-attach : capabilities})
(lsp.tailwindcss.setup {:on_attach on-attach : capabilities})
(lsp.kotlin_language_server.setup {:cmd [:/home/igneo676/.local/share/nvim/site/pack/packer/start/kotlin-language-server/server/build/install/server/bin/kotlin-language-server]
                                   :on_attach on-attach
                                   : capabilities
                                   :settings {:kotlin {:compiler {:jvm {:target :1.8}}}}})

(lsp.gradle_ls.setup {:cmd [:/home/igneo676/.local/share/nvim/site/pack/packer/start/vscode-gradle/gradle-language-server/build/install/gradle-language-server/bin/gradle-language-server]
                      :on_attach on-attach
                      : capabilities})

(tset (require :lspconfig.configs) :fennel_language_server
      {:default_config {:cmd [:fennel-language-server]
                        :filetypes [:fennel]
                        :single_file_support true
                        :root_dir (lsp.util.root_pattern :fnl)
                        :settings {:fennel {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                                            :diagnostics {:globals [:vim]}}}}})

; (lsp.fennel_language_server.setup {:on_attach on-attach : capabilities})

(tset (require :lspconfig.configs) :ideals
      {:default_config {:cmd [:android-studio-canary :lsp-server]
                        :filetypes [:kotlin]
                        :root_dir (vim.fs.dirname (. (vim.fs.find [:settings.gradle
                                                                   :settings.gradle.kts
                                                                   :build.gradle
                                                                   :build.gradle.kts]
                                                                  {:upward true})
                                                     1))}})

; (lsp.ideals.setup {:on_attach on-attach : capabilities})
