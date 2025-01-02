{1 :neovim/nvim-lspconfig
 :dependencies [:nvim-lua/plenary.nvim
                :pmizio/typescript-tools.nvim
                "https://git.sr.ht/~whynothugo/lsp_lines.nvim"]
 :opts {:servers {:fennel_ls {}}}
 :config (fn [_ opts]
           (let [lsp (require :lspconfig)
                 cmp (require :blink.cmp)
                 lsp_lines (require :lsp_lines)
                 typescript (require :typescript-tools)]
             (lsp_lines.setup {})
             (typescript.setup {:server {:init_options {:preferences {:allowIncompleteCompletions false
                                                                      :includeInlayParameterNameHints :all
                                                                      :includeInlayParameterNameHintsWhenArgumentMatchesName true
                                                                      :includeInlayFunctionParameterTypeHints true
                                                                      :includeInlayVariableTypeHints true
                                                                      :includeInlayPropertyDeclarationTypeHints true
                                                                      :includeInlayFunctionLikeReturnTypeHints true
                                                                      :includeInlayEnumMemberValueHints true
                                                                      :hostInfo :neovim}}}})
             ;; Loop through configured servers and set blink capabilities
             (each [server config (pairs opts.servers)]
               (set config.capabilities
                    (cmp.get_lsp_capabilities config.capabilities))
               ((. lsp server :setup) config))))}

