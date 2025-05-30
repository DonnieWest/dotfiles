{1 :saghen/blink.cmp
 :dependencies [:rafamadriz/friendly-snippets
                :saghen/blink.compat
                ; {1 :tzachar/cmp-ai
                ;  :opts {:ignored_file_types {}
                ;         :max_lines 1000
                ;         :notify true
                ;         :notify_callback (fn [msg] (vim.notify msg))
                ;         :provider :OpenAI
                ;         :provider_options {:model :gpt-4}
                ;         :run_on_every_keystroke true}}
                :kristijanhusak/vim-dadbod-completion
                {1 :David-Kunz/cmp-npm :ft :json :opts {}}
                :PaterJason/cmp-conjure]
 :init (fn []
         (let [cmp (require :blink.cmp)]
           (vim.keymap.set :i :<C-x><C-o>
                           (fn []
                             (cmp.show)
                             (cmp.show_documentation)
                             (cmp.hide_documentation))
                           {:silent false})))
 :opts {:appearance {:nerd_font_variant :mono :use_nvim_cmp_as_default true}
        :cmdline {:completion {:menu {:auto_show true}}
                  :keymap {:<Tab> [:select_next :fallback]
                           :<S-Tab> [:select_prev :fallback]}}
        :keymap {:preset :enter
                 :<Tab> [:select_next :fallback]
                 :<S-Tab> [:select_prev :fallback]}
        :signature {:enabled true}
        :completion {:ghost_text {:enabled false}
                     :menu {:draw {:treesitter [:lsp]}}
                     :documentation {:auto_show true :auto_show_delay_ms 500}
                     :list {:selection {:preselect true
                                        :auto_insert (fn [ctx]
                                                       (= ctx.mode :cmdline))}}}
        :sources {:default [:lsp
                            :easy-dotnet
                            :path
                            :snippets
                            :buffer
                            :conjure
                            :npm
                            :dadbod]
                  :providers {:npm {:name :npm :module :blink.compat.source}
                              :easy-dotnet {:module :easy-dotnet.completion.blink
                                            :name :easy-dotnet}
                              ; :cmp_ai {:name :cmp_ai
                              ;          :module :blink.compat.source}
                              :dadbod {:name :Dadbod
                                       :module :vim_dadbod_completion.blink}
                              :conjure {:name :conjure
                                        :module :blink.compat.source}}}}
 :build "cargo build --release"}

