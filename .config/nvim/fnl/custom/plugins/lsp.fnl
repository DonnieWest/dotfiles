{1 :neovim/nvim-lspconfig
 :dependencies [:nvim-lua/plenary.nvim
                :SmiteshP/nvim-navic
                :b0o/schemastore.nvim]
 :config (fn []
           (let [cmp (require :blink.cmp)
                 navic (require :nvim-navic)
                 data-path (vim.fn.stdpath :data)
                 lazy-path (fn [path] (.. data-path :/lazy/ path))
                 sysname (. (vim.uv.os_uname) :sysname)
                 jls-script (lazy-path (if (= sysname :Darwin)
                                           :jls/dist/lang_server_mac.sh
                                           :jls/dist/lang_server_linux.sh))
                 kotlin-ls (lazy-path :kotlin-language-server/server/build/install/server/bin/kotlin-language-server)
                 gradle-ls-bin (lazy-path :vscode-gradle/gradle-language-server/build/install/gradle-language-server/bin/gradle-language-server)
                 gradle-ls-wrapper (.. (vim.fn.stdpath :config) :/scripts/vscode-gradle-language-server-stdio.js)
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
                          :gradle_ls {:cmd [gradle-ls-wrapper gradle-ls-bin]
                                      :filetypes [:groovy :gradle]
                                      :root_markers [:settings.gradle
                                                     :settings.gradle.kts
                                                     :build.gradle
                                                     :build.gradle.kts]
                                      :init_options {:settings {:gradleWrapperEnabled true}}}
                          :marksman {}
                          :jsonls {:settings {:json {:schemas ((. (require :schemastore)
                                                                  :json :schemas))
                                                     :validate {:enable true}}}}
                          :tsc {:handlers {[:textDocument/publishDiagnostics] filter-ts7016}
                                :settings {:js/ts {:inlayHints {:parameterNames {:enabled :all
                                                                                :suppressWhenArgumentMatchesName false}
                                                                    :parameterTypes {:enabled true}
                                                                    :variableTypes {:enabled true}
                                                                    :propertyDeclarationTypes {:enabled true}
                                                                    :functionLikeReturnTypes {:enabled true}
                                                                    :enumMemberValues {:enabled true}}}
                                           :typescript {:preferences {:importModuleSpecifier :relative}}}}
                          :custom_elements_ls {:filetypes [:html
                                                           :javascript
                                                           :javascriptreact
                                                           :javascript.jsx
                                                           :typescript
                                                           :typescriptreact
                                                           :typescript.tsx]
                                               :handlers {[:textDocument/publishDiagnostics]
                                                          (fn [])}}}
                 on-attach (fn [client bufnr]
                             (navic.attach client bufnr))]
             (set vim.diagnostic.set
                  (fn [namespace bufnr diagnostics opts]
                    (diagnostic-set namespace bufnr
                                    (filter-ts7016-diagnostics diagnostics) opts)))
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
                                                       (local toggle-diagnostic-inline
                                                              (fn []
                                                                (let [config (vim.diagnostic.config)
                                                                      enabled (not (or config.virtual_text
                                                                                       config.virtual_lines))]
                                                                  (vim.diagnostic.config {:virtual_text enabled
                                                                                          :virtual_lines enabled}))))
                                                       (local toggle-inlay-hints
                                                              (fn []
                                                                (vim.lsp.inlay_hint.enable
                                                                 (not (vim.lsp.inlay_hint.is_enabled {: bufnr}))
                                                                 {: bufnr})))
                                                       (map :grr
                                                            builtin.lsp_references
                                                            "LSP references")
                                                       (map :<leader>uv
                                                            toggle-diagnostic-inline
                                                            "Toggle diagnostic inline text")
                                                       (map :<leader>uh
                                                            toggle-inlay-hints
                                                            "Toggle LSP inlay hints")
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
