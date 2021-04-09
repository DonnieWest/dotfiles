(module dotfiles.module.plugin.closetag
  {require {core aniseed.core
            nvim aniseed.nvim}})

(set nvim.g.closetag_xhtml_filenames "*.xhtml,*.js,*.tsx")

; This will make the list of non closing tags case sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
(set nvim.g.closetag_emptyTags_caseSensitive 1)
(set nvim.g.closetag_shortcut ">")
