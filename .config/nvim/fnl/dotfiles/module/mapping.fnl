(module dotfiles.module.mapping
  {require {nvim aniseed.nvim
            nu aniseed.nvim.util
            core aniseed.core}})

(defn noremap [mode from to]
  "Sets a mapping with {:noremap true}."
  (nvim.set_keymap mode from to {:noremap true}))

;; Generic mapping configuration.
(nvim.set_keymap :n :<space> :<nop> {:noremap true})
(set nvim.g.mapleader ",")

(noremap :n :<leader><space> ":call StripTrailingWhitespace()<cr>")

(nu.fn-bridge
  :StripTrailingWhitespace
  :dotfiles.module.mapping :strip-trailing-whitespace)

(defn strip-trailing-whitespace []
  (let [pos (nvim.fn.getpos ".")]
    (nvim.command "%s/\\s\\+$//e")
    (nvim.command "%s/\\n\\{3,}/\\r\\r/e")
    (nvim.command "%s#\\($\\n\\s*\\)\\+\\%$##e")
    (nvim.fn.setpos "." pos)))
