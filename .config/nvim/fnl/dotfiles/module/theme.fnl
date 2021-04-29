(module dotfiles.module.theme
  {require {treesitter nvim-treesitter.configs
            nvim aniseed.nvim}
   require-macros [dotfiles.macros]})

(treesitter.setup
  {:ensure_installed "all"
   :refactor {:smart_rename {:keymaps {:goto_definition "<c-]>"
                                       :list_definitions "gD"
                                       :goto_next_usage "<Leader>n"
                                       :goto_previous_usage "<Leader>N"}
                             :enable true}
              :highlight_definitions {:enable true}}
   :rainbow {:enable true}
   :autotag {:enable true}
   :highlight {:enable true
               :disable ["java" "kotlin"]}
   :indent {:enable true}})

(defn colorscheme-fixes []
  (_: hi :SpellBad :gui=underline)
  (_: hi :SpellLocal :gui=underline)
  (_: hi :SpellRare :gui=underline)
  (_: hi :htmlArg :gui=italic)
  (_: hi :Comment :gui=italic)
  (_: hi :Type    :gui=italic)
  (_: hi :Keywords :gui=italic)
  (_: hi :Keyword :gui=italic)
  (_: hi :Statement :gui=italic)
  (_: hi :Boolean :gui=italic)
  (_: hi :Constant :gui=italic)
  (_: hi :Include :gui=italic)
  (_: hi :ColorColumn :ctermbg=blue)

  (_: hi :NeogitDiffAdd :guifg=LightGray :guibg=DarkGreen)
  (_: hi :NeogitDiffDelete :guifg=DarkGray :guibg=DarkRed)
  (_: hi :NeogitDiffAddHighlight :guifg=LightGray :guibg=DarkGreen)
  (_: hi :NeogitDiffDeleteHighlight :guifg=DarkGray :guibg=DarkRed)
  (nvim.ex.highlight :link :NeogitDiffContextHighlight :CursorLine)
  (nvim.ex.highlight :link :NeogitHunkHeader :TabLine)
  (nvim.ex.highlight :link :NeogitHunkHeaderHighlight :DiffText))

(augroup gotham_colorscheme_fixes
  (autocmd :ColorScheme :gotham (viml->fn colorscheme-fixes)))

(_: colorscheme :gotham)
(nvim.fn.matchadd "ColorColumn" "\\%81v" 100)
