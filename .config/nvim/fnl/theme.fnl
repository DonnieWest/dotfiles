(module theme
  {require {treesitter nvim-treesitter.configs
            base16 base16
            au zest.au
            z zest.lib
            nvim aniseed.nvim}
   require-macros [zest.macros macros]})

(treesitter.setup
  {:ensure_installed "all"
   :refactor {:smart_rename {:keymaps {:goto_definition_lsp_fallback "<c-]>"
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

(defn- strip-hex-symbol [hex]
  (string.gsub hex "#" ""))

(defn- get-color [theme color]
  (strip-hex-symbol (. theme color)))

(defn- convert-theme-to-base16 [theme]
  {:base00 (get-color theme :background)
   :base01 (get-color theme :lighter-background)
   :base02 (get-color theme :selection)
   :base03 (get-color theme :comment)
   :base04 (get-color theme :dark-foreground)
   :base05 (get-color theme :foreground)
   :base06 (get-color theme :light-foreground)
   :base07 (get-color theme :light-background)
   :base08 (get-color theme :variables)
   :base09 (get-color theme :numbers)
   :base0A (get-color theme :classes)
   :base0B (get-color theme :strings)
   :base0C (get-color theme :regex)
   :base0D (get-color theme :functions)
   :base0E (get-color theme :keywords)
   :base0F (get-color theme :tags)})

(tset base16.themes :tweaked
  (convert-theme-to-base16
    {:background :#03090e
     :lighter-background :#061620
     :selection :#091f2e
     :comment :#223543
     :dark-foreground :#9da5ab
     :foreground :#e6e9ea
     :light-foreground :#f5fafd
     :light-background :#53626d
     :variables :#4e5166
     :numbers :#DDECB2
     :classes :#33859E
     :strings :#FFB610
     :regex :#195466
     :functions :#27B8C2
     :keywords :#ecb2c0
     :tags :#D12820 }))

(base16 base16.themes.tweaked true {:lightline true})

(au- [ColorScheme] *
     #(colorscheme-fixes))

(colorscheme-fixes)

(nvim.fn.matchadd "ColorColumn" "\\%81v" 100)
