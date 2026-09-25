{1 :saghen/blink.cmp
 :event [:InsertEnter :CmdlineEnter]
 :dependencies [:saghen/blink.lib
                :rafamadriz/friendly-snippets
                :saghen/blink.compat
                :kristijanhusak/vim-dadbod-completion
                {1 :David-Kunz/cmp-npm :ft :json :opts {}}
                :PaterJason/cmp-conjure]
 :config (fn [_ opts]
           (let [cmp (require :blink.cmp)
                 kotlin-completion (require :custom.kotlin_completion)]
             (cmp.setup opts)
             (kotlin-completion.register)
             (vim.keymap.set :i :<C-x><C-o>
                             (fn []
                               (cmp.show)
                               (cmp.show_documentation)
                               (cmp.hide_documentation))
                             {:silent false})))
 :opts {:appearance {:nerd_font_variant :mono :use_nvim_cmp_as_default true}
        :cmdline {:completion {:menu {:auto_show true}}
                  :keymap {:<Tab> [:show_and_insert_or_accept_single
                                   :select_next]
                           :<Up> [:select_prev :fallback]
                           :<Down> [:select_next :fallback]
                           :<S-Tab> [:show_and_insert_or_accept_single
                                     :select_prev]}}
        :keymap {:preset :enter
                 :<Tab> [(fn [cmp]
                           (when (cmp.is_active)
                             (cmp.insert_next)))
                         :fallback]
                 :<S-Tab> [(fn [cmp]
                             (when (cmp.is_active)
                               (cmp.insert_prev)))
                           :fallback]}
        :signature {:enabled true}
        :completion {:ghost_text {:enabled false}
                     :menu {:draw {:treesitter [:lsp]
                                   :columns [[:kind_icon :kind]
                                             {1 :label
                                              2 :label_description
                                              :gap 1}]}}
                     :documentation {:auto_show true :auto_show_delay_ms 500}
                     :list {:selection {:preselect true
                                        :auto_insert (fn [ctx]
                                                       (= ctx.mode :cmdline))}}}
        :sources {:default [:lsp :path :snippets :buffer]
                  :per_filetype {:javascript [:lsp]
                                 :javascriptreact [:lsp]
                                 :typescript [:lsp]
                                 :typescriptreact [:lsp]
                                 :cs [:lsp
                                      :path
                                      :easy-dotnet
                                      :snippets
                                      :buffer]
                                 :fsharp [:lsp
                                          :path
                                          :easy-dotnet
                                          :snippets
                                          :buffer]
                                 :clojure [:lsp
                                           :path
                                           :snippets
                                           :buffer
                                           :conjure]
                                 :fennel [:lsp
                                          :path
                                          :snippets
                                          :buffer
                                          :conjure]
                                 :json [:lsp :path :snippets :buffer :npm]
                                 :sql [:lsp :path :snippets :buffer :dadbod]}
                  :providers {:npm {:name :npm :module :blink.compat.source}
                              :easy-dotnet {:module :easy-dotnet.completion.blink
                                            :name :easy-dotnet}
                              :dadbod {:name :Dadbod
                                       :module :vim_dadbod_completion.blink}
                              :conjure {:name :conjure
                                        :module :blink.compat.source}}}}
 :build (fn []
          (let [cmp (require :blink.cmp)]
            (: (cmp.build) :pwait)))}
