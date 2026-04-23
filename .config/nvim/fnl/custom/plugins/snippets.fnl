;; nvim-scissors - Snippet management UI
;; Visual editor for creating and managing custom snippets
{1 :chrisgrieser/nvim-scissors
 :dependencies [:L3MON4D3/LuaSnip :nvim-telescope/telescope.nvim]
 :config (fn []
           (let [scissors (require :scissors)
                 vscode-loader (. (require :luasnip.loaders.from_vscode) :lazy_load)]
             (vscode-loader {:paths [(.. (vim.fn.stdpath :config) :/snippets)]})
             (scissors.setup {:snippetDir (.. (vim.fn.stdpath :config)
                                              :/snippets)
                              :editSnippetPopup {:height 0.4
                                                 :width 0.6
                                                 :border :rounded}
                              :telescope {:alsoSearchSnippetBody true}
                              :jsonFormatter :jq})))
 :keys [{1 :<leader>se
         2 (fn []
             (let [scissors (require :scissors)]
               (scissors.editSnippet)))
         :mode [:n :v]
         :desc "Edit snippet"}
        {1 :<leader>sa
         2 (fn []
             (let [scissors (require :scissors)]
               (scissors.addNewSnippet)))
         :mode [:n :v]
         :desc "Add new snippet"}]}
