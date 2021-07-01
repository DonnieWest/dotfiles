(module plugin.gehzu
  {require {nvim aniseed.nvim
            z zest.lib}})

(vim.schedule
  (fn []
    (nvim.ex.autocmd :FileType "fennel"
      "nnoremap <silent> <c-]> <cmd>lua require('nvim-gehzu').go_to_definition()<CR>")))
