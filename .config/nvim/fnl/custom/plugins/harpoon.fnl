{1 :ThePrimeagen/harpoon
 :branch :harpoon2
 :dependencies [:nvim-lua/plenary.nvim]
 :opts {:settings {:save_on_toggle true
                   :sync_on_ui_close true}}
 :keys [{1 :<leader>ha
         2 (fn []
             (let [harpoon (require :harpoon)]
               (harpoon:list):add))
         :desc "Harpoon add file"}
        {1 :<leader>hh
         2 (fn []
             (let [harpoon (require :harpoon)]
               (harpoon.ui:toggle_quick_menu (harpoon:list))))
         :desc "Harpoon menu"}
        {1 :<leader>h1
         2 (fn []
             (let [harpoon (require :harpoon)]
               ((. (harpoon:list) :select) (harpoon:list) 1)))
         :desc "Harpoon file 1"}
        {1 :<leader>h2
         2 (fn []
             (let [harpoon (require :harpoon)]
               ((. (harpoon:list) :select) (harpoon:list) 2)))
         :desc "Harpoon file 2"}
        {1 :<leader>h3
         2 (fn []
             (let [harpoon (require :harpoon)]
               ((. (harpoon:list) :select) (harpoon:list) 3)))
         :desc "Harpoon file 3"}
        {1 :<leader>h4
         2 (fn []
             (let [harpoon (require :harpoon)]
               ((. (harpoon:list) :select) (harpoon:list) 4)))
         :desc "Harpoon file 4"}
        {1 :<leader>hp
         2 (fn []
             (let [harpoon (require :harpoon)]
               ((. (harpoon:list) :prev) (harpoon:list))))
         :desc "Harpoon previous"}
        {1 :<leader>hn
         2 (fn []
             (let [harpoon (require :harpoon)]
               ((. (harpoon:list) :next) (harpoon:list))))
         :desc "Harpoon next"}]}
