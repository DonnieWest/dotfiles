(module plugin.sayonara {require {core aniseed.core
                                  nvim aniseed.nvim
                                  mapping mapping}})

(mapping.noremap :n :<C-Del> ":Sayonara<CR>")
(mapping.noremap :n "<ESC>[M" ":Sayonara<CR>")

