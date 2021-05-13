(module plugin.neoformat
  {require {nvim aniseed.nvim
            mapping mapping}})

(mapping.noremap :n :<leader>fm ":Neoformat<CR>")

(set nvim.g.neoformat_xml_prettier
     {:exe "prettier"
      :args ["--stdin" "--stdin-filepath" "\"%:p\""]
      :stdin 1})
(set nvim.g.neoformat_enabled_xml ["prettier"])
(set nvim.g.neoformat_enabled_typescript ["prettier"])
(set nvim.g.neoformat_enabled_javascript ["prettiereslint"])

(set nvim.g.neoformat_java_googleformatter
     {:exe "google-java-format"
      :args ["-"]
      :stdin 1})
(set nvim.g.neoformat_enabled_java ["googleformatter"])

(set nvim.g.neoformat_kotlin_ktlint
     {:exe "ktlint"
      :args ["-F" "-a" "--stdin"]
      :stdin 1})
(set nvim.g.neoformat_enabled_kotlin ["ktlint"])

