(module dotfiles.module.plugin.mundo
  {require {nvim aniseed.nvim}})

(nvim.set_keymap
  :n
  :<F2>
  ":MundoToggle<cr>"
  {:noremap true
   :silent true})
