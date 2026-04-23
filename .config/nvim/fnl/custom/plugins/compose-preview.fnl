{1 :nvim-lua/plenary.nvim
 :ft [:kotlin]
 :config (fn []
           (let [compose-preview (require :custom.compose-preview)]
             (compose-preview.setup)))}
