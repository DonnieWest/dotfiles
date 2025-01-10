{1 :monkoose/neocodeium
 :opts {}
 :init (fn []
         (vim.keymap.set :i :<A-f> (. (require :neocodeium) :accept)))}

