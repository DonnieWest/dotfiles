{1 :mfussenegger/nvim-lint
 :config #(let [lint (require :lint)]
            (vim.api.nvim_create_autocmd [:BufWritePost]
                                         {:callback #(lint.try_lint)})
            (set lint.linters_by_ft {:fennel [:fennel]}))}

