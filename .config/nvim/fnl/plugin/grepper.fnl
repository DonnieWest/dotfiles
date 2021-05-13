(module plugin.grepper
  {require {core aniseed.core
            nvim aniseed.nvim}})

(nvim.ex.runtime "plugin/grepper.vim")
(nvim.set_keymap :n :\ ":GrepperRg " {:noremap true})
