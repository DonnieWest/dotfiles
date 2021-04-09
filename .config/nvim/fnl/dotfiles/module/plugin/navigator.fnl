(module dotfiles.module.plugin.navigator
  {require {core aniseed.core
            nvim aniseed.nvim
            mapping dotfiles.module.mapping}})

(set nvim.g.tmux_navigator_no_mappings 1)

(mapping.noremap :n :<M-Left> ":TmuxNavigateLeft<CR>")
(mapping.noremap :n :<M-Down> ":TmuxNavigateDown<CR>")
(mapping.noremap :n :<Alt-Down> ":TmuxNavigateDown<CR>")
(mapping.noremap :n :<M-Up> ":TmuxNavigateUp<CR>")
(mapping.noremap :n :<M-Right> ":TmuxNavigateRight<CR>")

;; These mappings are used when nvim IS inside tmux

(mapping.noremap :n :<C-W>k ":TmuxNavigateUp<CR>")
(mapping.noremap :n :<C-W>j ":TmuxNavigateDown<CR>")
(mapping.noremap :n :<C-W>h ":TmuxNavigateLeft<CR>")
(mapping.noremap :n :<C-W>l ":TmuxNavigateRight<CR>")

(mapping.noremap :t :<M-Left> "<C-\\><C-n>:TmuxNavigateLeft<CR>")
(mapping.noremap :t :<M-Down> "<C-\\><C-n>:TmuxNavigateDown<CR>")
(mapping.noremap :t :<Alt-Down> "<C-\\><C-n>:TmuxNavigateDown<CR>")
(mapping.noremap :t :<M-Up> "<C-\\><C-n>:TmuxNavigateUp<CR>")
(mapping.noremap :t :<M-Right> "<C-\\><C-n>:TmuxNavigateRight<CR>")

;; These mappings are used when nvim IS inside tmux

(mapping.noremap :t :<C-W>k "<C-\\><C-n>:TmuxNavigateUp<CR>")
(mapping.noremap :t :<C-W>j "<C-\\><C-n>:TmuxNavigateDown<CR>")
(mapping.noremap :t :<C-W>h "<C-\\><C-n>:TmuxNavigateLeft<CR>")
(mapping.noremap :t :<C-W>l "<C-\\><C-n>:TmuxNavigateRight<CR>")
