{1 :saghen/blink.cmp
 :dependencies :rafamadriz/friendly-snippets
 :opts {:appearance {:nerd_font_variant :mono :use_nvim_cmp_as_default true}
        :keymap {:preset :default}
        :signature {:enabled true}
        :sources {:default [:lsp :path :snippets :buffer]}}
 :init (fn [] (require :custom/completion))
 :version "*"}

