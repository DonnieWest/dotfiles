(module mapping {require {nvim aniseed.nvim
                          nu aniseed.nvim.util
                          core aniseed.core}})

(defn noremap [mode from to] "Sets a mapping with {:noremap true}."
      (nvim.set_keymap mode from to {:noremap true :silent true}))

;; Generic mapping configuration.
(nvim.set_keymap :n :Q :<nop> {})
(nvim.set_keymap :n :<space> :<nop> {:noremap true})
(set nvim.g.mapleader ",")

(noremap :t :<Esc> "<C-\\><C-n>")

(noremap :n "!" ":!")
(noremap :n ";" ":")
(noremap :n :U ":redo<CR>")

(noremap :n :<Leader>v ":vsp<CR>")
(noremap :n :<Leader>h ":sp<CR>")

(noremap :n :<Leader>fr ":%s/")
(noremap :x :<Leader>fr ":s/")

;; Make visual selection more sane
(noremap :n :v :<C-V>)
(noremap :n :<C-V> :v)

(noremap :v :v :<C-V>)
(noremap :v :<C-V> :v)

;; Better indent
(noremap :v "<" :<gv)
(noremap :v ">" :>gv)

; Ctrl + Left and Right switch buffers
(noremap :n :<C-Right> ":bnext<CR>")
(noremap :n :<C-Left> ":bprevious<CR>")

(noremap :n :<Leader>t ":GrepperRg TODO: <CR>")

(noremap :n :<leader><space> ":call StripTrailingWhitespace()<cr>")

(nu.fn-bridge :StripTrailingWhitespace :mapping :strip-trailing-whitespace)

(defn strip-trailing-whitespace []
      (let [pos (nvim.fn.getpos ".")]
        (nvim.command "%s/\\s\\+$//e")
        (nvim.command "%s/\\n\\{3,}/\\r\\r/e")
        (nvim.command "%s#\\($\\n\\s*\\)\\+\\%$##e")
        (nvim.fn.setpos "." pos)))

