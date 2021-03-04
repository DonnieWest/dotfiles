(module dotfiles.module.plugin.ale
  {require {nvim aniseed.nvim}})

(set nvim.g.ale_linters
  {:javascript [:eslint]
   :cs [:OmniSharp]
   :java [:android]
   :python [:flake8 :mypy :pylint :pyls]
   :clojure [:clj-kondo :joker]
   :kotlin [:android :ktlint]})

(set nvim.g.ale_fixers
     {:javascript [:prettier_eslint]
      :rust [:rustfmt]
      :kotlin [:ktlint]})

(set nvim.g.ale_kotlin_ktlint_options "-aF --experimental")
(set nvim.g.ale_lint_on_enter 1)
(set nvim.g.ale_virtualtext_cursor 1)
(set nvim.g.ale_fix_on_save 1)
(set nvim.g.ale_completion_autoimport 1)
(set nvim.g.ale_hover_to_preview 0)
(set nvim.g.ale_set_balloons 1)
(set nvim.g.ale_rename_tsserver_find_in_comments 1)
(set nvim.g.ale_completion_tsserver_remove_items_without_detail 1)
(set nvim.g.ale_completion_tsserver_remove_warnings 1)
(set nvim.g.ale_hover_to_popup 1)

(set nvim.g.javascript_tsserver_use_global 1)

(set nvim.g.ale_kotlin_languageserver_executable "/home/igneo676/.config/nvim/plugged/kotlin-language-server/server/build/install/server/bin/kotlin-language-server")

(set nvim.g.ale_java_javalsp_executable "/home/igneo676/.config/nvim/plugged/java-language-server/dist/mac/bin/launcher")

(set nvim.g.ale_completion_symbols
     {:text ""
      :method ""
      :function ""
      :constructor ""
      :field ""
      :variable ""
      :class ""
      :interface ""
      :module ""
      :property ""
      :unit "unit"
      :value "val"
      :enum ""
      :keyword "keyword"
      :snippet ""
      :color "color"
      :file ""
      :reference "ref"
      :folder ""
      :enum_member ""
      :constant ""
      :struct ""
      :event "event"
      :operator ""
      :type_parameter "type param"
      :<default> "v"
      })
