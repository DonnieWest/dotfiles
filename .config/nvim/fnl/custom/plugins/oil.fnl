{1 :stevearc/oil.nvim
 :opts {:keymaps {:<C-p> false}}
 :init (fn []
         (vim.keymap.set :n "-" :<CMD>Oil<CR> {:desc "Open parent directory"}))}

