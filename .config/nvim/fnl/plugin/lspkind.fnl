(module plugin.lspkind
  {require {nvim aniseed.nvim
            lspkind lspkind}})

(lspkind.init
  {:with_text false
   :symbol_map {:Text ""
                :Method ""
                :Function ""
                :Constructor ""
                :Field ""
                :Variable ""
                :Class ""
                :Interface ""
                :Module ""
                :Property ""
                :Unit "unit"
                :Value "val"
                :Enum ""
                :Keyword "keyword"
                :Snippet "﬌"
                :Color "color"
                :File ""
                :EnumMember ""
                :Constant ""
                :Struct ""}})
