(module plugin.auto-pairs
        {require {core aniseed.core nvim aniseed.nvim autopairs nvim-autopairs}})

(autopairs.setup {:check_ts true})

(local lisps [:scheme :lisp :clojure :fennel])

(tset (. (autopairs.get_rules "'") 1) :not_filetypes lisps)

(local backrules (autopairs.get_rules "`"))
(tset (. backrules 1) :not_filetypes lisps)
