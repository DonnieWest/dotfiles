{:url "https://codeberg.org/andyg/leap.nvim"
 :keys [{1 :s :mode [:n :x :o]}
        {1 :S :mode [:n :x :o]}
        {1 :gs :mode :n}
        {1 :x :mode [:x :o]}
        {1 :X :mode [:x :o]}]
 :config (fn []
           (vim.keymap.set [:n :x :o] :s "<Plug>(leap-forward)")
           (vim.keymap.set [:n :x :o] :S "<Plug>(leap-backward)")
           (vim.keymap.set :n :gs "<Plug>(leap-from-window)")
           (vim.keymap.set [:x :o] :x "<Plug>(leap-forward-till)")
           (vim.keymap.set [:x :o] :X "<Plug>(leap-backward-till)"))}
