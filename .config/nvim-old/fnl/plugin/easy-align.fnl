(module plugin.easy-align {require {core aniseed.core
                                    nvim aniseed.nvim
                                    mapping mapping}})

(nvim.set_keymap :n :ga "<Plug>(EasyAlign)" {:silent true})
(nvim.set_keymap :x :ga "<Plug>(EasyAlign)" {:silent true})

