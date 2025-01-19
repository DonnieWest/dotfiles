{1 :goolord/alpha-nvim
 :dependencies [:nvim-tree/nvim-web-devicons]
 :config (fn []
           (let [startify (require :alpha.themes.startify)
                 alpha (require :alpha)]
             (set startify.file_icons_provider :devicons)
             (alpha.setup startify.config)))}
