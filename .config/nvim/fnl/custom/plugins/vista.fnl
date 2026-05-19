{1 :stevearc/aerial.nvim
 :dependencies [:nvim-treesitter/nvim-treesitter]
 :cmd [:AerialToggle :AerialOpen :AerialClose]
 :keys [{1 :<leader>o 2 :<cmd>AerialToggle!<cr> :desc :Outline}]
 :opts {:backends [:treesitter :lsp :markdown :asciidoc :man]}}
