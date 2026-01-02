{1 :ggandor/leap.nvim
 :config (fn []
           (vim.keymap.set [:n :x :o] :s "<Plug>(leap-forward)")
           (vim.keymap.set [:n :x :o] :S "<Plug>(leap-backward)")
           (vim.keymap.set :n :gs "<Plug>(leap-from-window)")
           (vim.keymap.set [:x :o] :x "<Plug>(leap-forward-till)")
           (vim.keymap.set [:x :o] :X "<Plug>(leap-backward-till)"))}
