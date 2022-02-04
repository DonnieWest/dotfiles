(module plugin.cmp {require {nvim aniseed.nvim
                             :nu aniseed.nvim.util
                             cmp cmp
                             cmp_git cmp_git
                             lspkind lspkind
                             lsp cmp_nvim_lsp
                             lspconfig lspconfig}})

(fn has-words-before []
  (let [(line col) (unpack (vim.api.nvim_win_get_cursor 0))]
    (and (not= col 0) (= (: (: (. (vim.api.nvim_buf_get_lines 0 (- line 1) line
                                                              true)
                                  1) :sub col
                               col) :match "%s") nil))))

(fn feedkey [key mode]
  (vim.api.nvim_feedkeys (vim.api.nvim_replace_termcodes key true true true)
                         mode true))

(cmp.setup {:mapping {:<CR> (cmp.mapping.confirm {:select true})
                      :<Tab> (cmp.mapping (fn [fallback]
                                            (if (cmp.visible)
                                                (cmp.select_next_item)
                                                (= ((. vim.fn "vsnip#available") 1)
                                                   1)
                                                (feedkey "<Plug>(vsnip-expand-or-jump)"
                                                         "")
                                                (has-words-before)
                                                (cmp.complete)
                                                (fallback)))
                                          [:i :s])
                      :<S-Tab> (cmp.mapping (fn []
                                              (if (cmp.visible)
                                                  (cmp.select_prev_item)
                                                  (= ((. vim.fn
                                                         "vsnip#jumpable") (- 1))
                                                     1)
                                                  (feedkey "<Plug>(vsnip-jump-prev)"
                                                           "")))
                                            [:i :s])
                      :<C-e> (cmp.mapping {:i (cmp.mapping.abort)
                                           :c (cmp.mapping.close)})
                      :<C-x><C-o> (cmp.mapping (cmp.mapping.complete) [:i :c])}
            :formatting {:format (lspkind.cmp_format {:maxwidth 80})}
            :snippet {:expand (fn [args]
                                ((. vim.fn "vsnip#anonymous") args.body))}
            :experimental {:ghost_text true}
            :sources [{:name :conjure}
                      {:name :nvim_lsp}
                      {:name :nvim_lua}
                      {:name :path}
                      {:name :vsnip}
                      {:name :cmp_git}
                      {:name :vim-dadbod-completion}]})

(nvim.ex.set "completeopt=menuone,noselect")

(cmp_git.setup)
