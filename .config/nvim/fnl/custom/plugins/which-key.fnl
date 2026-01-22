{1 :folke/which-key.nvim
 :event :VeryLazy
 :opts {:preset :helix
        :delay 300
        :icons {:mappings false
                :keys {:Up "<Up> "
                       :Down "<Down> "
                       :Left "<Left> "
                       :Right "<Right> "
                       :C "<C-…> "
                       :M "<M-…> "
                       :D "<D-…> "
                       :S "<S-…> "
                       :CR "<CR> "
                       :Esc "<Esc> "
                       :ScrollWheelDown "<ScrollWheelDown> "
                       :ScrollWheelUp "<ScrollWheelUp> "
                       :NL "<NL> "
                       :BS "<BS> "
                       :Space "<Space> "
                       :Tab "<Tab> "
                       :F1 "<F1>"
                       :F2 "<F2>"
                       :F3 "<F3>"
                       :F4 "<F4>"
                       :F5 "<F5>"
                       :F6 "<F6>"
                       :F7 "<F7>"
                       :F8 "<F8>"
                       :F9 "<F9>"
                       :F10 "<F10>"
                       :F11 "<F11>"
                       :F12 "<F12>"}}}
 :keys [{1 :<leader>?
         2 (fn []
             (let [wk (require :which-key)]
               (wk.show {:global false})))
         :desc "Buffer Local Keymaps"}]}
