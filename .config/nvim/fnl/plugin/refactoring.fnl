(module plugin.refactoring {require {nvim aniseed.nvim mapping mapping refactoring refactoring}})

(refactoring.setup {})

(mapping.noremap :v :<Leader>rv
                 ":lua require('refactoring').debug.print_var({})<CR>")

(mapping.noremap :n :<Leader>rp
                 ":lua require('refactoring').debug.printf({below = false})<CR>")

