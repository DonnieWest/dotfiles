(module plugin.null {require {nvim aniseed.nvim null null-ls}})

(null.setup {:sources [null.builtins.formatting.stylua
                       null.builtins.diagnostics.eslint
                       null.builtins.completion.spell
                       (require :typescript.extensions.null-ls.code-actions)]})

