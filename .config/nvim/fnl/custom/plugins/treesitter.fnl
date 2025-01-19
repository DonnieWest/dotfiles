(fn merge-and-set-hl [group new-settings]
  (let [old-settings (vim.api.nvim_get_hl 0 {:name group})
        ;; Get existing highlight settings
        merged-settings (vim.tbl_extend :force old-settings new-settings)]
    ;; Merge with new settings
    (vim.api.nvim_set_hl 0 group merged-settings)))

(fn colorscheme-fixes []
  (let [italic-groups [:TSComment
                       :TSType
                       :TSKeywords
                       :jsGlobalNodeObjects
                       :JSKeywords
                       :jsFunction
                       :TSKeyword
                       :TSStatement
                       :TSBoolean
                       :TSConstant
                       :TSInclude
                       :htmlArg
                       :Comment
                       :Type
                       :Keywords
                       :Keyword
                       :Statement
                       :Boolean
                       :Constant
                       :Include]
        underline-groups [:SpellBad :SpellLocal :SpellRare]]
    ;; Set italic highlights
    (each [index group (ipairs italic-groups)]
      (merge-and-set-hl group {:italic true}))
    ;; Set underline highlights
    (each [index group (ipairs underline-groups)]
      (merge-and-set-hl group {:underline true}))
    ;; Set specific highlights
    (merge-and-set-hl :ColorColumn {:ctermbg :blue})
    (merge-and-set-hl :NeogitDiffAdd {:fg :LightGray :bg :Green})
    (merge-and-set-hl :NeogitDiffDelete {:fg :DarkGray :bg :Red})
    (merge-and-set-hl :NeogitDiffAddHighlight {:fg :LightGray :bg :DarkGreen})
    (merge-and-set-hl :NeogitDiffDeleteHighlight {:fg :DarkGray :bg :DarkRed})
    ;; Set links for other groups
    (vim.api.nvim_set_hl 0 :NeogitDiffContextHighlight {:link :CursorLine})
    (vim.api.nvim_set_hl 0 :NeogitHunkHeader {:link :TabLine})
    (vim.fn.matchadd :ColorColumn "\\%101v" 100)
    (vim.api.nvim_set_hl 0 :NeogitHunkHeaderHighlight {:link :DiffText})))

{1 :nvim-treesitter/nvim-treesitter
 :build ":TSUpdate"
 :dependencies [:RRethy/nvim-treesitter-endwise
                :nvim-treesitter/playground
                :nvim-treesitter/nvim-treesitter-textobjects
                :nvim-treesitter/nvim-treesitter-refactor]
 :init (fn []
         (colorscheme-fixes)
         (vim.api.nvim_create_autocmd [:ColorScheme]
                                      {:callback colorscheme-fixes}))
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

