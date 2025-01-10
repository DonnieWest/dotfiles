{1 :vuki656/package-info.nvim
 :opts {}
 :init (fn []
         (vim.api.nvim_create_autocmd [:BufEnter :BufWritePost]
                                      {:pattern :package.json
                                       :callback #(package.show)}))}

