(module dotfiles.module.plugin.tcomment
  {require {nvim aniseed.nvim}})

; call tcomment#type#Define('kotlin',       tcomment#GetLineC('// %s'))
; call tcomment#type#Define('kotlin_block', g:tcomment#block_fmt_c   )
; call tcomment#type#Define('kotlin_inline', g:tcomment#inline_fmt_c )
;

; "Make TComment work as I expect
; noremap <leader>/ :TComment <CR>
; vmap <leader>/ :TCommentBlock<CR>
;
