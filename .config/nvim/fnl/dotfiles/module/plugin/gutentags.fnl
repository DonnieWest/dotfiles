(module dotfiles.module.plugin.gutentags
  {require {core aniseed.core
            nu aniseed.nvim.util
            nvim aniseed.nvim}})

(set nvim.g.gutentags_ctags_tagfile ".tags")
(set nvim.g.gutentags_exclude_filetypes ["java" "xml" "gradle" "kotlin"])
