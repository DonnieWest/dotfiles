(module plugin.luasnip {require {nvim aniseed.nvim
                                 vscode luasnip.loaders.from_vscode
                                 snipmate luasnip.loaders.from_snipmate
                                 types luasnip.util.types
                                 extras luasnip.extras
                                 luasnip luasnip}})

(vscode.lazy_load)
(snipmate.lazy_load)

(luasnip.config.setup {:ext_opts {types.choiceNode {:active {:virt_text [["●"
                                                                          "#D12820"]]}}
                                  types.insertNode {:active {:virt_text [["●"
                                                                          "#FFB610"]]}}}})

(set luasnip.snippets
     {:fennel [(luasnip.snippet :module
                                [(luasnip.text_node "(module plugin.")
                                 (luasnip.insert_node 0)
                                 (luasnip.text_node " {require {nvim aniseed.nvim}})")])]
      :kotlin [(luasnip.snippet :moshi
                                [(luasnip.text_node ["@JsonClass(generateAdapter = true)"
                                                     "data class "])
                                 (luasnip.insert_node 1)
                                 (luasnip.text_node "(")
                                 (luasnip.snippet_node 0
                                                       [(luasnip.text_node "val ")
                                                        (luasnip.insert_node 1)
                                                        (luasnip.text_node ":")
                                                        (luasnip.insert_node 2)])
                                 (luasnip.text_node ")")])]})

