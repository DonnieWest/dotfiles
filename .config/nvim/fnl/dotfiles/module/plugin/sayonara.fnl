(module dotfiles.module.plugin.sayonara
  {require {core aniseed.core
            nvim aniseed.nvim
            mapping dotfiles.module.mapping}})

(mapping.noremap :n :<C-Del> ":Sayonara<CR>")
