{1 :saghen/blink.cmp
 :dependencies :rafamadriz/friendly-snippets
 :opts {:appearance {:nerd_font_variant :mono :use_nvim_cmp_as_default true}
        :keymap {:preset :enter}
        :signature {:enabled true}
        :completion {:ghost_text {:enabled true}
                     :documentation {:auto_show true :auto_show_delay_ms 500}
                     :list {:selection (fn [ctx]
                                         (or (and (= ctx.mode :cmdline)
                                                  :auto_insert)
                                             :preselect))}}
        :sources {:default [:lsp :path :snippets :buffer]}}
 :init (fn []
         (set vim.opt.completeopt "menuone,noselect")
         (require :custom/completion))
 :version "*"}
