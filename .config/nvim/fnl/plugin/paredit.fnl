(module plugin.parinfer
        {require {nvim aniseed.nvim
                  paredit nvim-paredit
                  fennel-paredit nvim-paredit-fennel}})

(fennel-paredit.setup)

(paredit.setup {:indent {:enabled true}})

