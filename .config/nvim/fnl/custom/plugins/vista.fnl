{1 :liuchengxu/vista.vim
 :init (fn []
         (vim.api.nvim_create_autocmd [:VimEnter]
                                      {:pattern "*"
                                       :command "call vista#RunForNearestMethodOrFunction()"}))}

