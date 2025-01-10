{1 :mhartington/formatter.nvim
 :init (fn []
         (vim.keymap.set :n :<leader>fm ":Format<CR>"))
 :opts {:filetype {:fennel [(fn []
                              {:exe :fnlfmt :args ["-"] :stdin true})]
                   ; :javascript ((. (require :formatter.util) :copyf
                   ;                 (. (require :formatter.defaults) :prettier)))
                   :kotlin [(fn []
                              {:exe :ktfmt :args ["-"] :stdin true})]}}}

