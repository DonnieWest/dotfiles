{1 :nvim-treesitter/nvim-treesitter-textobjects
 :branch :main
 :config (fn []
           (let [textobjects (require :nvim-treesitter-textobjects)
                 move (require :nvim-treesitter-textobjects.move)
                 select (require :nvim-treesitter-textobjects.select)]
             (textobjects.setup {:move {:set_jumps true}
                                 :select {:lookahead true}})
             (vim.keymap.set [:n :x :o] "]m"
                             #(move.goto_next_start "@function.outer"
                                                    :textobjects))
             (vim.keymap.set [:n :x :o] "]]"
                             #(move.goto_next_start "@class.outer" :textobjects))
             (vim.keymap.set [:n :x :o] "]M"
                             #(move.goto_next_end "@function.outer"
                                                  :textobjects))
             (vim.keymap.set [:n :x :o] "]["
                             #(move.goto_next_end "@class.outer" :textobjects))
             (vim.keymap.set [:n :x :o] "[m"
                             #(move.goto_previous_start "@function.outer"
                                                        :textobjects))
             (vim.keymap.set [:n :x :o] "[["
                             #(move.goto_previous_start "@class.outer"
                                                        :textobjects))
             (vim.keymap.set [:n :x :o] "[M"
                             #(move.goto_previous_end "@function.outer"
                                                      :textobjects))
             (vim.keymap.set [:n :x :o] "[]"
                             #(move.goto_previous_end "@class.outer"
                                                      :textobjects))
             (vim.keymap.set [:x :o] :af
                             #(select.select_textobject "@function.inner"
                                                        :textobjects))
             (vim.keymap.set [:x :o] :if
                             #(select.select_textobject "@function.outer"
                                                        :textobjects))
             (vim.keymap.set [:x :o] :ag
                             #(select.select_textobject "@class.outer"
                                                        :textobjects))
             (vim.keymap.set [:x :o] :ig
                             #(select.select_textobject "@class.inner"
                                                        :textobjects))
             (vim.keymap.set [:x :o] :ac
                             #(select.select_textobject "@comment.outer"
                                                        :textobjects))))}
