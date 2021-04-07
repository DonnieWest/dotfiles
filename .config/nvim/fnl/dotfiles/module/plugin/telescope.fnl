(module dotfiles.module.plugin.telescope
  {require {nvim aniseed.nvim
            mapping dotfiles.module.mapping}})

(mapping.noremap :n :<C-p> ":lua require'telescope.builtin'.find_files{}<CR>")
