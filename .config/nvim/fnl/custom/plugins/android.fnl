{1 :hsanson/vim-android
 :ft [:kotlin]
 :config (fn []
           (let [android (require :custom.android)]
             (android.setup)))}
