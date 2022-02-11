(module plugin.telescope {require {nvim aniseed.nvim
                                   telescope telescope
                                   actions telescope.actions
                                   builtin telescope.builtin
                                   mapping mapping}})

(telescope.setup {:defaults {:mappings {:i {:<esc> actions.close}}}
                  :extensions {:frecency {:workspaces {:config :$HOME/.config}}
                               :fzf {:fuzzy true
                                     :override_generic_sorter true
                                     :override_file_sorter true
                                     :case_mode :smart_case}}})

(each [_ value (ipairs [:fzf :frecency :refactoring :dap])]
  (telescope.load_extension value))

(defn telescopeFindFiles []
      (if (= (vim.fn.getcwd) (vim.fn.expand :$HOME))
          (telescope.extensions.frecency.frecency)
          (builtin.find_files)))

(mapping.noremap :n :<C-p>
                 ":lua require('plugin.telescope').telescopeFindFiles()<CR>")

(mapping.noremap :n "\\" ":Telescope live_grep<CR>")

(mapping.noremap :v :<Leader>rr
                 "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>")
