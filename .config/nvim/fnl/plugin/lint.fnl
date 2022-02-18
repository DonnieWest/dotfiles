(module plugin.lint {require {nvim aniseed.nvim lint lint}})

(nvim.ex.autocmd :BufWritePost "*" ":lua require('lint').try_lint()")

(tset lint :linters_by_ft {:markdown []})

