{1 :saghen/blink.cmp
 :dependencies [:rafamadriz/friendly-snippets
                :saghen/blink.compat
                :PaterJason/cmp-conjure]
 :opts {:appearance {:nerd_font_variant :mono :use_nvim_cmp_as_default true}
        :keymap {:preset :enter
                 :cmdline {:<Tab> [:select_next :fallback]
                           :<S-Tab> [:select_prev :fallback]}}
        :signature {:enabled true}
        :completion {:ghost_text {:enabled true}
                     :documentation {:auto_show true :auto_show_delay_ms 500}
                     :list {:selection {:preselect true
                                        :auto_insert (fn [ctx]
                                                       (= ctx.mode :cmdline))}}}
        :sources {:default [:lsp :path :snippets :buffer :conjure]
                  :providers {:conjure {:name :conjure
                                        :module :blink.compat.source}}}}
 :build "cargo build --release"}

