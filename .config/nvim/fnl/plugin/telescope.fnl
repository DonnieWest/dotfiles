(module plugin.telescope {require {nvim aniseed.nvim
                                   telescope telescope
                                   actions telescope.actions
                                   mapping mapping}})

(telescope.setup {:defaults {:mappings {:i {:<esc> actions.close}}}
                  :extensions {:frecency {:workspaces {:config :$HOME/.config}}
                               :fzf {:fuzzy true
                                     :override_generic_sorter true
                                     :override_file_sorter true
                                     :case_mode :smart_case}}})

(each [_ value (ipairs [:fzf :frecency])]
  (telescope.load_extension value))

(mapping.noremap :n :<C-p> ":Telescope find_files<CR>")
(mapping.noremap :n "\\" ":Telescope live_grep<CR>")

