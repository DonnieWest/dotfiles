(module plugin.neocodeium
        {require {core aniseed.core nvim aniseed.nvim neocodeium neocodeium}})

(neocodeium.setup {})

(vim.keymap.set :i :<A-f> neocodeium.accept)
