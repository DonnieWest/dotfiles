(module dotfiles.module.plugin.gitgutter
  {require {nvim aniseed.nvim
            au zest.au
            z zest.lib}
   require-macros [zest.macros]})

(au- [BufWritePost] *
     #(nvim.command "GitGutter"))

(au-user- [ALELintPost]
     #(nvim.command "GitGutter"))

(au-user- [NeogitStatusRefreshed]
     #(nvim.command "GitGutterAll"))

(set nvim.g.gitgutter_max_signs 10000)
