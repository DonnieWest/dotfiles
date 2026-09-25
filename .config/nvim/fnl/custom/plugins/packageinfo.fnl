{1 :vuki656/package-info.nvim
 :ft :json
 :opts {}
 :init (fn []
         (vim.api.nvim_create_autocmd [:BufEnter :BufWritePost]
                                      {:pattern :package.json
                                       :callback (. (require :package-info)
                                                    :show)}))}
