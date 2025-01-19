{1 :tomtom/tcomment_vim
 :dependencies [{1 :JoosepAlviste/nvim-ts-context-commentstring :opts {}}]
 :init #(let [opts {:silent true :noremap true}]
          ; (vim.fn.tcomment#type#Define :kotlin
          ;                              (vim.fn.tcomment#GetLineC "// %s"))
          ; (vim.fn.tcomment#type#Define :kotlin_block vim.g.tcomment#block_fmt_c)
          ; (vim.fn.tcomment#type#Define :kotlin_inline
          ;                              vim.g.tcomment#inline_fmt_c)

          (vim.keymap.set :v :<leader>/ ":TCommentBlock<CR>" opts)
          (vim.keymap.set :n :<leader>/ ":TComment<CR>" opts))}

