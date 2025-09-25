{1 :mhartington/formatter.nvim
 :init (fn []
         (vim.keymap.set :n :<leader>fm ":Format<CR>"))
 :config (fn []
           (local defaults (require :formatter.defaults))
           (local util (require :formatter.util))
           (local formatter (require :formatter))
           (formatter.setup {:filetype {:fennel [(fn []
                                                   {:exe :fnlfmt
                                                    :args ["-"]
                                                    :stdin true})]
                                        :javascript (util.copyf defaults.prettier)
                                        :typescript (util.copyf defaults.prettier)
                                        :html (util.copyf defaults.prettier)
                                        :java [(fn []
                                                 {:exe :google-java-format
                                                  :stdin true
                                                  :args ["-"]})]
                                        :kotlin [(fn []
                                                   {:exe :ktfmt
                                                    :args ["-"]
                                                    :stdin true})]}}))}
