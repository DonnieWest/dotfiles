; (fn colorscheme-fixes [] (run-ex hi :TSComment :gui=italic)
;       (run-ex hi :TSType :gui=italic) (run-ex hi :TSKeywords :gui=italic)
;       (run-ex hi :jsGlobalNodeObjects :gui=italic) (run-ex hi :JSKeywords :gui=italic)
;       (run-ex hi :jsFunction :gui=italic) (run-ex hi :JSKeywords :gui=italic)
;       (run-ex hi :TSKeyword :gui=italic) (run-ex hi :TSStatement :gui=italic)
;       (run-ex hi :TSBoolean :gui=italic) (run-ex hi :TSConstant :gui=italic)
;       (run-ex hi :TSInclude :gui=italic) (run-ex hi :SpellBad :gui=underline)
;       (run-ex hi :SpellLocal :gui=underline)
;       (run-ex hi :SpellRare :gui=underline) (run-ex hi :htmlArg :gui=italic)
;       (run-ex hi :Comment :gui=italic) (run-ex hi :Type :gui=italic)
;       (run-ex hi :Keywords :gui=italic) (run-ex hi :Keyword :gui=italic)
;       (run-ex hi :Statement :gui=italic) (run-ex hi :Boolean :gui=italic)
;       (run-ex hi :Constant :gui=italic) (run-ex hi :Include :gui=italic)
;       (run-ex hi :ColorColumn :ctermbg=blue)
;       (run-ex hi :NeogitDiffAdd :guifg=LightGray :guibg=DarkGreen)
;       (run-ex hi :NeogitDiffDelete :guifg=DarkGray :guibg=DarkRed)
;       (run-ex hi :NeogitDiffAddHighlight :guifg=LightGray :guibg=DarkGreen)
;       (run-ex hi :NeogitDiffDeleteHighlight :guifg=DarkGray :guibg=DarkRed)
;       (nvim.ex.highlight :link :NeogitDiffContextHighlight :CursorLine)
;       (nvim.ex.highlight :link :NeogitHunkHeader :TabLine)
;       (nvim.ex.highlight :link :NeogitHunkHeaderHighlight :DiffText))

{1 :nvim-treesitter/nvim-treesitter
 :build ":TSUpdate"
 :dependencies [:RRethy/nvim-treesitter-endwise
                :nvim-treesitter/playground
                :nvim-treesitter/nvim-treesitter-textobjects
                :nvim-treesitter/nvim-treesitter-refactor]
 :opts {:ensure_installed :all
        :ignore_install [:php :phpdoc]
        :query_linter {:enable true
                       :use_virtual_text true
                       :lint_events [:BufWrite :CursorHold]}
        :endwise {:enable true}
        :matchup {:enable true}
        :refactor {:smart_rename {:keymaps {:smart_rename :grr} :enable true}
                   :navigation {:keymaps {:goto_definition_lsp_fallback "<c-]>"
                                          :list_definitions :gD
                                          :goto_next_usage :<Leader>n
                                          :goto_previous_usage :<Leader>N}
                                :enable true}}
        :textobjects {:lsp_interop {:peek_definition_code {:<Leader>df "@function.outer"
                                                           :<Leader>dF "@class.outer"}
                                    :border false
                                    :enable true}
                      :move {:enable true
                             :set_jumps true
                             :goto_next_start {"]m" "@function.outer"
                                               "]]" "@class.outer"}
                             :goto_next_end {"]M" "@function.outer"
                                             "][" "@class.outer"}
                             :goto_previous_start {"[m" "@function.outer"
                                                   "[[" "@class.outer"}
                             :goto_previous_end {"[M" "@function.outer"
                                                 "[]" "@class.outer"}}
                      :select {:keymaps {:af "@function.inner"
                                         :if "@function.outer"
                                         :ag "@class.outer"
                                         :ig "@class.inner"
                                         :ac "@comment.outer"}
                               :enable true}}
        :autotag {:enable true}
        :highlight {:enable true :additional_vim_regex_highlighting true}
        :indent {:enable true}}}

