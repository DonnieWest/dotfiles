{1 :mhinz/vim-sayonara
 :init (fn []
         (vim.keymap.set :n :<C-Del> ":Sayonara<CR>")
         (vim.keymap.set :n "<ESC>[M" ":Sayonara<CR>"))}

