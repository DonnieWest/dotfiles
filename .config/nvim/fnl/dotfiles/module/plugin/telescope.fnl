(module dotfiles.module.plugin.telescope
  {require {nvim aniseed.nvim
            telescope telescope
            previewers telescope.previewers
            mapping dotfiles.module.mapping}})

(mapping.noremap :n :<C-p> ":lua require'telescope.builtin'.find_files{}<CR>")

(telescope.setup
  {:defaults
   {:file_previewer previewers.cat.new
    :git_previewer previewers.vimgrep.new }})
