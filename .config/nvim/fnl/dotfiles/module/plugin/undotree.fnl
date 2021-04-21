(module dotfiles.module.plugin.undotree
  {require {nvim aniseed.nvim}})

(nvim.set_keymap
  :n
  :<F2>
  ":UndotreeToggle<cr>"
  {:noremap true
   :silent true})
