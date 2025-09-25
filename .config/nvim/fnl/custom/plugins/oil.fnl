{1 :stevearc/oil.nvim
 :opts {:keymaps {:<C-p> false} :view_options {:show_hidden true}}
 :init (fn []
         (vim.keymap.set :n "-" :<CMD>Oil<CR> {:desc "Open parent directory"}))}
