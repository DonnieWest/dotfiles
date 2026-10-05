{1 :hsanson/vim-android
 :ft [:kotlin :java :groovy :xml]
 :config (fn []
           ((. (require :custom.android) :setup))
           ((. (require :custom.compose-preview) :setup)))}
