(module dotfiles.module.plugin.conjure
  {require {nvim aniseed.nvim}})

(set nvim.g.conjure#eval#result_register "*")
(set nvim.g.conjure#log#botright true)
(set nvim.g.conjure#log#hud#enabled true)
(set nvim.g.conjure#log#hud#height 0.2)
(set nvim.g.conjure#extract#tree_sitter#enabled true)
