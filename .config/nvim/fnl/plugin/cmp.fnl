(module plugin.cmp {require {nvim aniseed.nvim
                             cmp cmp
                             npm cmp-npm
                             git cmp_git
                             luasnip luasnip
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

(cmp.setup {:mapping (cmp.mapping.preset.insert {:<CR> (cmp.mapping.confirm {:select true})
                                                 :<Tab> (cmp.mapping (fn [fallback]
                                                                       (if (cmp.visible)
                                                                           (cmp.select_next_item)
                                                                           (luasnip.expand_or_locally_jumpable)
                                                                           (luasnip.expand_or_jump)
                                                                           (has-words-before)
                                                                           (cmp.complete)
                                                                           (fallback)))
                                                                     [:i :s])
                                                 :<S-Tab> (cmp.mapping (fn [fallback]
                                                                         (if (cmp.visible)
                                                                             (cmp.select_prev_item)
                                                                             (luasnip.jumpable (- 1))
                                                                             (luasnip.jump (- 1))
                                                                             (fallback))
                                                                         [:i
                                                                          :s]))
                                                 :<C-e> (cmp.mapping {:i (cmp.mapping.abort)
                                                                      :c (cmp.mapping.close)})
                                                 :<C-x><C-o> (cmp.mapping (cmp.mapping.complete)
                                                                          [:i
                                                                           :c])})
            :formatting {:format (lspkind.cmp_format {:maxwidth 80})}
            :snippet {:expand (fn [args]
                                (luasnip.lsp_expand args.body))}
            :experimental {:ghost_text true}
            :sources [{:name :conjure}
                      {:name :nvim_lsp}
                      {:name :nvim_lsp_signature_help}
                      {:name :npm :keyword_length 4}
                      {:name :nvim_lua}
                      {:name :path}
                      {:name :luasnip}
                      {:name :cmp_git}
                      {:name :vim-dadbod-completion}]})

(nvim.ex.set "completeopt=menuone,noselect")

(git.setup)

(npm.setup)

