(module dotfiles.module.plugin.startify
  {require {core aniseed.core
            nvim aniseed.nvim}
   require-macros [zest.macros]})

(set nvim.g.startify_custom_header [])
(set nvim.g.startify_change_to_vcs_root 1)
(set nvim.g.startify_bookmarks [{:c "~/.config/nvim/init.vim"}])
