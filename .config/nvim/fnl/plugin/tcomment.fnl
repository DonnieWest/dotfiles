(module plugin.tcomment {require {nvim aniseed.nvim mapping mapping}})

(nvim.fn.tcomment#type#Define :kotlin (nvim.fn.tcomment#GetLineC "// %s"))
(nvim.fn.tcomment#type#Define :kotlin_block nvim.g.tcomment#block_fmt_c)
(nvim.fn.tcomment#type#Define :kotlin_inline nvim.g.tcomment#inline_fmt_c)

(mapping.noremap :n :<leader>/ ":TComment<CR>")
(mapping.noremap :v :<leader>/ ":TCommentBlock<CR>")

(mapping.noremap :n :gbc ":TCommentBlock<CR>")
(mapping.noremap :v :gb ":TCommentBlock<CR>")
