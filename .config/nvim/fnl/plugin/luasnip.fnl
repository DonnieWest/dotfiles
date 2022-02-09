(module plugin.luasnip {require {nvim aniseed.nvim
                                 vscode luasnip.loaders.from_vscode
                                 snipmate luasnip.loaders.from_snipmate
                                 types luasnip.util.types
                                 luasnip luasnip}})

(vscode.lazy_load)
(snipmate.lazy_load)

(luasnip.config.setup {:ext_opts {types.choiceNode {:active {:virt_text [["●"
                                                                          :Orange]]}
                                                    types.insertNode {:active {:virt_text [["●"
                                                                                            :Blue]]}}}}})

