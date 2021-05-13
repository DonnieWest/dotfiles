(module theme
  {require {treesitter nvim-treesitter.configs
            base16 base16
            au zest.au
            z zest.lib
            nvim aniseed.nvim}
   require-macros [zest.macros macros]})

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

(tset base16.themes :gotham
  (base16.theme_from_array
    [:0c1014 ; Background
     :11151c ; Lighter Background
     :091f2e ; Selection
     :0a3749 ; Comment
     :245361 ; Dark Foreground
     :d3ebe9 ; Foreground
     :599cab ; Light Foreground
     :98d1ce ; Light Background
     :4e5166 ; Variables
     :2aa889 ; Integers
     :33859E ; Classes
     :edb443 ; Strings
     :195466 ; Support / Regex
     :888ca6 ; Functions
     :d26937 ; Tags/Keywords
     :c23127 ; Deprecated, open/closing tags
    ]))

(tset base16.themes :nightowl
  (base16.theme_from_array
    [:011627 ; Background
     :01111d ; Lighter Background
     :1d3b53 ; Selection
     :637777 ; Comment
     :ffffff ; Dark foreground
     :d6deeb ; Foreground
     :80a4c2 ; Light Foreground
     :575656 ; Light Background
     :4b6479 ; Variables
     :c5e4fd ; Integers
     :c792ea ; Classes
     :22da6e ; Strings
     :82aaff ; Support / Regex
     :21c7a8 ; Functions
     :7fdbca ; Tags/Keywords
     :addb67 ; Deprecated, open/closing tags
     ]))

(base16 base16.themes.gotham true {:lightline true})

(au- [ColorScheme] *
     #(colorscheme-fixes))

(colorscheme-fixes)

(nvim.fn.matchadd "ColorColumn" "\\%81v" 100)
