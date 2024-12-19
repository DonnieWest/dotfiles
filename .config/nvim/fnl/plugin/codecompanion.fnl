(module plugin.codecompanion
        {require {nvim aniseed.nvim
                  codecompanion codecompanion
                  adapters codecompanion.adapters}})

(codecompanion.setup {:strategies {:chat {:adapter :codellama}
                                   :inline {:adapter :codellama}}
                      :adapters {:codellama (fn []
                                              (adapters.extend :ollama
                                                               {:name :codellama
                                                                :schema {:model {:default "qwen2.5-coder:7b"}
                                                                         :num_ctx {:default -1}
                                                                         :num_predict {:default -1}}}))}})

(vim.api.nvim_set_keymap :n :<C-a> :<cmd>CodeCompanionActions<cr>
                         {:noremap true :silent true})

(vim.api.nvim_set_keymap :v :<C-a> :<cmd>CodeCompanionActions<cr>
                         {:noremap true :silent true})

(vim.api.nvim_set_keymap :n :<LocalLeader>a "<cmd>CodeCompanionChat Toggle<cr>"
                         {:noremap true :silent true})

(vim.api.nvim_set_keymap :v :<LocalLeader>a "<cmd>CodeCompanionChat Toggle<cr>"
                         {:noremap true :silent true})

(vim.api.nvim_set_keymap :v :ga "<cmd>CodeCompanionChat Add<cr>"
                         {:noremap true :silent true})

