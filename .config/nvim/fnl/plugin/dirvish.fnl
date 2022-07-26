(module plugin.dirvish {require {core aniseed.core nvim aniseed.nvim}})

(nvim.ex.autocmd :FileType :dirvish "silent! unmap <buffer> <C-p>")
(nvim.ex.autocmd :FileType :dirvish "silent! unmap <buffer> <C-n>")
