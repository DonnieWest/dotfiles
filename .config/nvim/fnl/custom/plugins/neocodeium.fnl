{1 :monkoose/neocodeium
 :opts {}
 :init #(let [codeium (require :neocodeium)]
          (vim.keymap.set :i :<A-f> codeium.accept))}

