(module plugin.vista
  {require {core aniseed.core
            nvim aniseed.nvim}})

(nvim.ex.autocmd :VimEnter :* "call vista#RunForNearestMethodOrFunction()")
