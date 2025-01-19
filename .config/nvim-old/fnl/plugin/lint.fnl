(module plugin.lint {require {nvim aniseed.nvim lint lint}})

(vim.api.nvim_create_autocmd [:BufWritePost] {:callback #(lint.try_lint)})

(tset lint :linters_by_ft {:markdown []})

