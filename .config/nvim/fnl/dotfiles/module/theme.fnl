(module dotfiles.module.theme
  {require {treesitter nvim-treesitter.configs
            nvim aniseed.nvim}
   require-macros [dotfiles.macros]})

(treesitter.setup
  {:ensure_installed "all"
   :highlight {:enable true
               :disable ["clojure" "kotlin" "java"]}
   :indent {:enable true}})

(defn colorscheme-fixes []
  (_: hi :SpellBad :gui=underline)
  (_: hi :SpellLocal :gui=underline)
  (_: hi :SpellRare :gui=underline)
  (_: hi :htmlArg :cterm=italic)
  (_: hi :Comment :cterm=italic)
  (_: hi :Type    :cterm=italic)
  (_: hi :Keywords :cterm=italic)
  (_: hi :xmlAttrib :cterm=italic :ctermfg=214)
  (_: hi :jsxAttrib :cterm=italic)
  (_: hi :Statement :cterm=italic)
  (_: hi :Keyword :cterm=italic)
  (_: hi :Constant :cterm=italic)
  (_: hi :Boolean :cterm=italic)
  (_: hi :ktInclude :cterm=italic)
  (_: hi :Type :cterm=italic)
  (_: hi :htmlArg :gui=italic)
  (_: hi :Comment :gui=italic)
  (_: hi :Type    :gui=italic)
  (_: hi :Keywords :gui=italic)
  (_: hi :xmlAttrib :gui=italic :ctermfg=214)
  (_: hi :jsxAttrib :gui=italic)
  (_: hi :Statement :gui=italic)
  (_: hi :Keyword :gui=italic)
  (_: hi :Constant :gui=italic)
  (_: hi :Boolean :gui=italic)
  (_: hi :ktInclude :gui=italic)
  (_: hi :Type :gui=italic)
  (_: hi :ColorColumn :ctermbg=blue))

(augroup gotham_colorscheme_fixes
  (autocmd :ColorScheme :gotham (viml->fn colorscheme-fixes)))

(_: colorscheme :gotham)
(nvim.fn.matchadd "ColorColumn" "\\%81v" 100)
