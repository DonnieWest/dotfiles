(module plugin.actions {require {core aniseed.core
                                 nvim aniseed.nvim
                                 actions actions}})

(actions.setup {:log_level vim.log.levels.INFO
                :actions {"Example action" (fn []
                                             {:filetypes [:help]
                                              :steps [(.. "echo 'Current file: "
                                                          (vim.fn.expand "%:p")
                                                          "'")]})}})

