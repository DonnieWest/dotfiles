{1 :neovim/nvim-lspconfig
 :dependencies [:nvim-lua/plenary.nvim
                :pmizio/typescript-tools.nvim
                :SmiteshP/nvim-navic
                :b0o/schemastore.nvim]
 :config (fn []
           (let [cmp (require :blink.cmp)
                 typescript (require :typescript-tools)
                 navic (require :nvim-navic)
                 servers {:fennel_ls {}
                          :csharp_ls {}
                          :jls {:cmd [(.. (vim.fn.stdpath :data)
                                          :/lazy/jls/dist/lang_server_linux.sh)
                                      :--status]
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
                                :init_options {}
                                :on-attach (fn [client bufnr]
                                             (when (= client.name :jls)
                                               (vim.keymap.set :n :<leader>jla
                                                               vim.lsp.buf.code_action
                                                               {:buffer 0
                                                                :desc "jls code action"})))}
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
                                 :root_markers [:tsconfig.json
                                                :jsconfig.json
                                                :package.json
                                                :.git]}}
                 on-attach (fn [client bufnr]
                             (navic.attach client bufnr))]
             (typescript.setup {: on-attach
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
                                                       (vim.keymap.set :n :grr
                                                                       builtin.lsp_references)
                                                       (vim.keymap.set :n
                                                                       :<F19>
                                                                       vim.lsp.buf.rename)
                                                       (vim.keymap.set :n :gd
                                                                       builtin.lsp_definitions)
                                                       (vim.keymap.set :n :gD
                                                                       vim.lsp.buf.declaration)
                                                       (vim.keymap.set :n
                                                                       "<c-]>"
                                                                       vim.lsp.buf.definition)
                                                       (vim.keymap.set :n :K
                                                                       vim.lsp.buf.hover)
                                                       (vim.lsp.inlay_hint.enable true
                                                                                  {: bufnr})
                                                       (vim.keymap.set :n
                                                                       :<c-k>
                                                                       vim.lsp.buf.signature_help)
                                                       (vim.keymap.set :n :gW
                                                                       builtin.lsp_workspace_symbols)
                                                       (vim.keymap.set :n :gT
                                                                       vim.lsp.buf.type_definition
                                                                       {:buffer 0})
                                                       (vim.keymap.set :n :grn
                                                                       vim.lsp.buf.rename
                                                                       {:buffer 0})
                                                       (vim.keymap.set :n :gra
                                                                       vim.lsp.buf.code_action
                                                                       {:buffer 0})
                                                       (vim.keymap.set :n :g0
                                                                       builtin.lsp_document_symbols
                                                                       {:buffer 0}))})
             (each [server config (pairs servers)]
               (set config.capabilities
                    (cmp.get_lsp_capabilities config.capabilities))
               (vim.lsp.config server
                               (vim.tbl_extend :force config {: on-attach}))
               (vim.lsp.enable server))))}
