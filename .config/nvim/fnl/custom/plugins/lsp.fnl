{1 :neovim/nvim-lspconfig
 :dependencies [:nvim-lua/plenary.nvim
                :pmizio/typescript-tools.nvim
                :SmiteshP/nvim-navic
                :b0o/schemastore.nvim]
 :config (fn []
           (let [cmp (require :blink.cmp)
                 typescript (require :typescript-tools)
                 navic (require :nvim-navic)
                 data-path (vim.fn.stdpath :data)
                 lazy-path (fn [path] (.. data-path :/lazy/ path))
                 sysname (. (vim.uv.os_uname) :sysname)
                 jls-script (lazy-path (if (= sysname :Darwin)
                                           :jls/dist/lang_server_mac.sh
                                           :jls/dist/lang_server_linux.sh))
                 kotlin-ls (lazy-path :kotlin-language-server/server/build/install/server/bin/kotlin-language-server)
                 diagnostic-set vim.diagnostic.set
                 filter-ts7016-diagnostics (fn [diagnostics]
                                             (vim.tbl_filter (fn [diagnostic]
                                                               (let [code (or diagnostic.code
                                                                              (and diagnostic.user_data
                                                                                   diagnostic.user_data.lsp
                                                                                   diagnostic.user_data.lsp.code))]
                                                                 (not= (tostring code)
                                                                       :7016)))
                                                             (or diagnostics [])))
                 filter-ts7016 (fn [err result ctx config]
                                 (when result
                                   (set result.diagnostics
                                        (filter-ts7016-diagnostics result.diagnostics)))
                                 (vim.lsp.diagnostic.on_publish_diagnostics err
                                                                            result
                                                                            ctx
                                                                            config))
                 servers {:fennel_ls {}
                          :csharp_ls {}
                          :jls {:cmd [jls-script :--status]
                                :filetypes [:java]
                                :root_markers [:.git
                                               :pom.xml
                                               :build.gradle
                                               :build.gradle.kts
                                               :settings.gradle
                                               :settings.gradle.kts]
                                :settings {:java {:classPath []
                                                  :externalDependencies []
                                                  :trace {:server :off}}}
                                :init_options {}}
                          :kotlin_language_server {:cmd [kotlin-ls]
                                                   :filetypes [:kotlin]
                                                   :root_markers [:.git
                                                                  :build.gradle
                                                                  :build.gradle.kts
                                                                  :settings.gradle
                                                                  :settings.gradle.kts
                                                                  :pom.xml]
                                                   :settings {:kotlin {:compiler {:jvmTarget :1.8}}
                                                              :hints {:parameterNames {:enabled true}
                                                                      :typeHints {:enabled true}}}}
                          ; IMPORTANT: For Android projects, ensure ANDROID_HOME is set
                          ; and the project has been built at least once with './gradlew build'
                          :marksman {}
                          :jsonls {:settings {:json {:schemas ((. (require :schemastore)
                                                                  :json :schemas))
                                                     :validate {:enable true}}}}
                          :tsgo {:cmd [:tsgo :--lsp :-stdio]
                                 :filetypes [:javascript
                                             :javascriptreact
                                             :javascript.jsx
                                             :typescript
                                             :typescriptreact
                                             :typescript.tsx]
                                 :handlers {[:textDocument/publishDiagnostics] filter-ts7016}
                                 :root_markers [:tsconfig.json
                                                :jsconfig.json
                                                :package.json
                                                :.git]}}
                 on-attach (fn [client bufnr]
                             (navic.attach client bufnr))]
             (set vim.diagnostic.set
                  (fn [namespace bufnr diagnostics opts]
                    (diagnostic-set namespace bufnr
                                    (filter-ts7016-diagnostics diagnostics) opts)))
             (typescript.setup {: on-attach
                                :settings {:tsserver_plugins ["@lit-labs/tsserver-plugin"]}
                                :handlers {[:textDocument/publishDiagnostics] filter-ts7016}
                                :server {:init_options {:preferences {:allowIncompleteCompletions false
                                                                      :includeInlayParameterNameHints :all
                                                                      :includeInlayParameterNameHintsWhenArgumentMatchesName true
                                                                      :includeInlayFunctionParameterTypeHints true
                                                                      :includeInlayVariableTypeHints true
                                                                      :includeInlayPropertyDeclarationTypeHints true
                                                                      :includeInlayFunctionLikeReturnTypeHints true
                                                                      :includeInlayEnumMemberValueHints true
                                                                      :importModuleSpecifierPreference :relative
                                                                      :jsxAttributeCompletionStyle :auto
                                                                      :hostInfo :neovim}
                                                        :maxTsServerMemory 8192}}})
             (vim.diagnostic.config {:virtual_text false :virtual_lines true})
             (vim.api.nvim_create_autocmd :LspAttach
                                          {:callback (fn [args]
                                                       (local bufnr args.buf)
                                                       (local client
                                                              (assert (vim.lsp.get_client_by_id args.data.client_id)
                                                                      "must have valid client"))
                                                       (local builtin
                                                              (require :telescope.builtin))
                                                       (set vim.opt_local.omnifunc
                                                            "v:lua.vim.lsp.omnifunc")
                                                       (local map
                                                              (fn [lhs
                                                                   rhs
                                                                   desc]
                                                                (vim.keymap.set :n
                                                                                lhs
                                                                                rhs
                                                                                {:buffer bufnr
                                                                                 : desc})))
                                                       (map :grr
                                                            builtin.lsp_references
                                                            "LSP references")
                                                       (map :<F19>
                                                            vim.lsp.buf.rename
                                                            "LSP rename")
                                                       (map :gd
                                                            builtin.lsp_definitions
                                                            "LSP definitions")
                                                       (map :gD
                                                            vim.lsp.buf.declaration
                                                            "LSP declaration")
                                                       (map "<c-]>"
                                                            vim.lsp.buf.definition
                                                            "LSP definition")
                                                       (map :K
                                                            vim.lsp.buf.hover
                                                            "LSP hover")
                                                       (vim.lsp.inlay_hint.enable true
                                                                                  {: bufnr})
                                                       (map :<c-k>
                                                            vim.lsp.buf.signature_help
                                                            "LSP signature help")
                                                       (map :gW
                                                            builtin.lsp_workspace_symbols
                                                            "LSP workspace symbols")
                                                       (map :gT
                                                            vim.lsp.buf.type_definition
                                                            "LSP type definition")
                                                       (map :grn
                                                            vim.lsp.buf.rename
                                                            "LSP rename")
                                                       (map :gra
                                                            vim.lsp.buf.code_action
                                                            "LSP code action")
                                                       (map :g0
                                                            builtin.lsp_document_symbols
                                                            "LSP document symbols")
                                                       (when (= client.name
                                                                :jls)
                                                         (map :<leader>jla
                                                              vim.lsp.buf.code_action
                                                              "jls code action")))})
             (each [server config (pairs servers)]
               (set config.capabilities
                    (cmp.get_lsp_capabilities config.capabilities))
               (vim.lsp.config server
                               (vim.tbl_extend :force config {: on-attach}))
               (vim.lsp.enable server))))}
