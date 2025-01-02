[{1 :ibhagwan/fzf-lua
  :init (fn []
          (vim.api.nvim_create_autocmd :FileType
                                       {:pattern :fzf
                                        :group (vim.api.nvim_create_augroup :fzf
                                                                            {})
                                        :callback "tnoremap <buffer> <esc> <c-c>"}))}
 {1 :nvim-telescope/telescope.nvim
  :dependencies [{1 :nvim-telescope/telescope-fzf-native.nvim :build :make}
                 {1 :nvim-telescope/telescope-ui-select.nvim}
                 {1 :ThePrimeagen/refactoring.nvim
                  :opts {}
                  :init (fn []
                          (vim.keymap.set :v :<Leader>rv
                                          (fn []
                                            (((. (require :refactoring) :debug
                                                 :print_var) {}))))
                          (vim.keymap.set :n :<Leader>rp
                                          (fn []
                                            (((. (require :refactoring) :debug
                                                 :printf) {:below false})))))}
                 {1 :nvim-telescope/telescope-frecency.nvim
                  :dependencies [:tami5/sqlite.lua]}]
  :init (fn []
          (local telescope (require :telescope))
          (local builtin (require :telescope.builtin))
          (each [_ value (ipairs [:fzf :frecency :refactoring :ui-select])]
            (telescope.load_extension value))

          (fn telescopeFindFiles []
            (if (= (vim.fn.getcwd) (vim.fn.expand :$HOME))
                (telescope.extensions.frecency.frecency)
                (builtin.find_files)))

          (vim.keymap.set :n :<C-p> telescopeFindFiles)
          (vim.keymap.set :n "\\" ":Telescope live_grep<CR>")
          (vim.keymap.set :v :<Leader>rr
                          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>"))
  :opts (fn []
          (local actions (require :telescope.actions))
          {:defaults {:vimgrep_arguments [:rg
                                          :--color=never
                                          :--no-heading
                                          :--with-filename
                                          :--line-number
                                          :--column
                                          :--smart-case
                                          :--hidden
                                          :--follow
                                          :-g
                                          :!.git/]
                      :mappings {:i {:<esc> actions.close}}}
           :extensions {:frecency {:workspaces {:config :$HOME/.config}}
                        :fzf {:fuzzy true
                              :override_generic_sorter true
                              :override_file_sorter true
                              :case_mode :smart_case}}})}]

