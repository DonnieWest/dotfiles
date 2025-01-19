(module plugin.parinfer
        {require {nvim aniseed.nvim
                  paredit nvim-paredit}})

(paredit.setup {:indent {:enabled true}})
