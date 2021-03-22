(module dotfiles.module.theme
  {require {treesitter nvim-treesitter.configs
            nvim aniseed.nvim}
   require-macros [dotfiles.macros]})

(treesitter.setup
  {:ensure_installed "all"
   :refactor {:smart_rename {:keymaps {:goto_definition "gnd"
                                       :list_definitions "gnD"
                                       :list_definitions_toc "gO"
                                       :goto_next_usage "<a-*>"
                                       :goto_previous_usage "<a-#>"}
                             :enable true}
              :highlight_definitions {:enable true}}
   :rainbow {:enable true}
   :highlight {:enable true
               :disable ["java"]}
   :indent {:enable true}})

(defn colorscheme-fixes []
  (_: hi :SpellBad :gui=underline)
  (_: hi :SpellLocal :gui=underline)
  (_: hi :SpellRare :gui=underline)
  (_: hi :htmlArg :cterm=italic)
  (_: hi :Comment :cterm=italic)
  (_: hi :Type    :cterm=italic)
  (_: hi :Keywords :cterm=italic)
  (_: hi :Keyword :cterm=italic)
  (_: hi :Statement :cterm=italic)
  (_: hi :Boolean :cterm=italic)
  (_: hi :Constant :cterm=italic)
  (_: hi :xmlAttrib :cterm=italic :ctermfg=214)
  (_: hi :jsxAttrib :cterm=italic)
  (_: hi :ktInclude :cterm=italic)
  (_: hi :ColorColumn :ctermbg=blue))

(augroup gotham_colorscheme_fixes
  (autocmd :ColorScheme :gotham (viml->fn colorscheme-fixes)))

(_: colorscheme :gotham)
(nvim.fn.matchadd "ColorColumn" "\\%81v" 100)
