(module plugin.package-info
        {require {core aniseed.core nvim aniseed.nvim package package-info}})

(package.setup)

(vim.api.nvim_create_autocmd [:BufEnter :BufWritePost]
                             {:pattern :package.json :callback #(package.show)})

