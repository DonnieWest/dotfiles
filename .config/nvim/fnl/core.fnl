(module core
  {require {nvim aniseed.nvim
            au zest.au
            z zest.lib}
   require-macros [zest.macros]})

(nvim.ex.autocmd :BufWritePost :init.vim "so $MYVIMRC")
(nvim.ex.autocmd :VimResized ":windcmd =")
(nvim.ex.autocmd :FocusGained :* ":checktime")
(nvim.ex.autocmd :TextYankPost :* "lua vim.highlight.on_yank { higroup=\"IncSearch\", timeout=100}")

;; Restore previous cursor permission
(au- [BufReadPost] *
     #(nvim.fn.setpos "." (nvim.fn.getpos "'\"")))
