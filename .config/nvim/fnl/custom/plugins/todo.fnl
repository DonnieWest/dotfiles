;; todo-comments.nvim - Highlight and search TODO comments
;; Provides syntax highlighting and telescope integration for TODO, FIXME, NOTE, etc.
{1 :folke/todo-comments.nvim
 :dependencies [:nvim-lua/plenary.nvim :nvim-telescope/telescope.nvim]
 :event :VeryLazy
 :config (fn []
           (let [todo (require :todo-comments)]
             (todo.setup {:signs true
                          :sign_priority 8
                          :keywords {:TODO {:icon " " :color :info}
                                     :FIXME {:icon " "
                                             :color :error
                                             :alt [:FIX :BUG]}
                                     :HACK {:icon " " :color :warning}
                                     :WARN {:icon " "
                                            :color :warning
                                            :alt [:WARNING]}
                                     :PERF {:icon " "
                                            :alt [:PERFORMANCE :OPTIMIZE]}
                                     :NOTE {:icon " "
                                            :color :hint
                                            :alt [:INFO]}}
                          :highlight {:before ""
                                      :keyword :wide
                                      :after :fg
                                      :pattern ".*<(KEYWORDS)\\s*:"
                                      :comments_only true
                                      :max_line_len 400}})))
 :keys [{1 :<leader>td 2 :<cmd>TodoTelescope<cr> :desc "Todo list (Telescope)"}
        {1 "]t"
         2 (fn [] ((require :todo-comments) .jump_next))
         :desc "Next todo comment"}
        {1 "[t"
         2 (fn [] ((require :todo-comments) .jump_prev))
         :desc "Previous todo comment"}]}
