{1 :neovim/nvim-lspconfig
 :dependencies [:nvim-lua/plenary.nvim
                :pmizio/typescript-tools.nvim
                :jubnzv/virtual-types.nvim
                :SmiteshP/nvim-navic
                :b0o/schemastore.nvim
                {1 :VidocqH/lsp-lens.nvim :opts {}}
                {1 :lewis6991/hover.nvim
                 :opts {:init (fn []
                                (require :hover.providers.lsp))}}
                "https://git.sr.ht/~whynothugo/lsp_lines.nvim"]
 :config #(let [lsp (require :lspconfig)
                cmp (require :blink.cmp)
                lsp_lines (require :lsp_lines)
                typescript (require :typescript-tools)
                virtualtypes (require :virtualtypes)
                navic (require :nvim-navic)
                servers {:fennel_ls {}
                         :jsonls {:settings {:json {:schemas ((. (require :schemastore)
                                                                 :json :schemas))
                                                    :validate {:enable true}}}}}
                on-attach (fn [client bufnr]
                            (virtualtypes.on_attach client bufnr)
                            (navic.attach client bufnr))]
            (lsp_lines.setup {})
            (typescript.setup {: on-attach
                               :server {:init_options {:preferences {:allowIncompleteCompletions false
                                                                     :includeInlayParameterNameHints :all
                                                                     :includeInlayParameterNameHintsWhenArgumentMatchesName true
                                                                     :includeInlayFunctionParameterTypeHints true
                                                                     :includeInlayVariableTypeHints true
                                                                     :includeInlayPropertyDeclarationTypeHints true
                                                                     :includeInlayFunctionLikeReturnTypeHints true
                                                                     :includeInlayEnumMemberValueHints true
                                                                     :hostInfo :neovim}}}})
            (vim.diagnostic.config {:virtual_text true :virtual_lines false})
            (vim.api.nvim_create_autocmd :LspAttach
                                         {:callback (fn [args] ; (vim.keymap.del :n :K {:buffer args.buf})
                                                      (local bufnr args.buf)
                                                      (local client
                                                             (assert (vim.lsp.get_client_by_id args.data.client_id)
                                                                     "must have valid client"))
                                                      (local builtin
                                                             (require :telescope.builtin))
                                                      (set vim.opt_local.omnifunc
                                                           "v:lua.vim.lsp.omnifunc")
                                                      ; Some keymaps are created unconditionally when Nvim starts:
                                                      ; "grn" is mapped in Normal mode to vim.lsp.buf.rename()
                                                      ; "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
                                                      ; "grr" is mapped in Normal mode to vim.lsp.buf.references()
                                                      ; "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
                                                      ; "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
                                                      ; CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()
                                                      (vim.keymap.set :n :grr
                                                                      builtin.lsp_references)
                                                      (vim.keymap.set :n :<F19>
                                                                      vim.lsp.buf.rename)
                                                      (vim.keymap.set :n :gd
                                                                      builtin.lsp_definitions)
                                                      (vim.keymap.set :n :gD
                                                                      vim.lsp.buf.declaration)
                                                      (vim.keymap.set :n
                                                                      "<c-]>"
                                                                      vim.lsp.buf.definition)
                                                      (vim.keymap.set :n :K
                                                                      (. (require :hover)
                                                                         :hover))
                                                      (vim.api.nvim_create_autocmd :CursorHold
                                                                                   {:callback (. (require :hover)
                                                                                                 :hover)})
                                                      (vim.keymap.set :n :<c-k>
                                                                      vim.lsp.buf.signature_help)
                                                      (vim.keymap.set :n :gW
                                                                      builtin.lsp_workspace_symbols)
                                                      (vim.keymap.set :n :gT
                                                                      vim.lsp.buf.type_definition
                                                                      {:buffer 0})
                                                      (vim.keymap.set :n :grr
                                                                      vim.lsp.buf.rename
                                                                      {:buffer 0})
                                                      (vim.keymap.set :n :gra
                                                                      vim.lsp.buf.code_action
                                                                      {:buffer 0})
                                                      (vim.keymap.set :n :g0
                                                                      builtin.lsp_document_symbols
                                                                      {:buffer 0}))})
            ;; Loop through configured servers and set blink capabilities
            (each [server config (pairs servers)]
              (set config.capabilities
                   (cmp.get_lsp_capabilities config.capabilities))
              ((. lsp server :setup) (vim.tbl_extend :force config
                                                     {: on-attach}))))}

