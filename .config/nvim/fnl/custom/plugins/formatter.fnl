{1 :stevearc/conform.nvim
 :init (fn []
         (vim.keymap.set :n :<leader>fm
                         (fn []
                           ((. (require :conform) :format) {:async true
                                                            :lsp_format :fallback}))
                         {:desc "Format buffer"}))
 :opts {:formatters_by_ft {:fennel [:fnlfmt]
                           :javascript [:prettier]
                           :javascriptreact [:prettier]
                           :typescript [:prettier]
                           :typescriptreact [:prettier]
                           :html [:prettier]
                           :css [:prettier]
                           :scss [:prettier]
                           :json [:prettier]
                           :jsonc [:prettier]
                           :markdown [:prettier]
                           :java [:google-java-format]
                           :kotlin [:ktfmt]}
        :formatters {:prettier {:command (fn [_ ctx]
                                          (let [matches (vim.fs.find :node_modules/.bin/prettier
                                                                     {:path ctx.dirname
                                                                      :upward true
                                                                      :type :file})]
                                            (or (. matches 1) :prettier)))}
                     :fnlfmt {:command :fnlfmt :args ["-"] :stdin true}
                     :google-java-format {:command :google-java-format
                                          :args ["-"]
                                          :stdin true}
                     :ktfmt {:command :ktfmt :args ["-"] :stdin true}}}}
