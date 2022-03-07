(module core {require {nvim aniseed.nvim}})

(nvim.ex.autocmd :BufWritePost :init.vim "so $MYVIMRC")
(nvim.ex.autocmd :VimResized ":windcmd =")
(nvim.ex.autocmd :FocusGained "*" ":checktime")

(vim.api.nvim_create_autocmd [:TextYankPost]
                             {:callback #(vim.highlight.on_yank {:higroup :IncSearch
                                                                 :timeout 100})})

;; Restore previous cursor permission
(vim.api.nvim_create_autocmd [:BufReadPost]
                             {:desc "set position after vim loads"
                              :callback #(nvim.fn.setpos "."
                                                         (nvim.fn.getpos "'\""))})

