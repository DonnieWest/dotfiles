(module plugin.esearch
  {require {nvim aniseed.nvim}
   require-macros [macros]})

(set nvim.g.esearch
     {:adapter :rg
      :backend :nvim
      :out :win
      :batch_size 1000
      :use [:visual :hlsearch :last]})

(vim.fn.esearch#map "<leader>ff" "esearch")

(_: hi :ESearchMatch :ctermfg=black :ctermbg=white :guifg=#000000 :guibg=#E6E6FA)
