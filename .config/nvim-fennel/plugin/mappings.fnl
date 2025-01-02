(local keymap vim.keymap)

;; keymap.set leader key
(set vim.g.mapleader ",")

;; Generic mappings
(keymap.set :n :Q :<nop>)
(keymap.set :n :<space> :<nop> {:noremap true})

;; Escape terminal mode with <C-\><C-n>
(keymap.set :t :<Esc> "<C-\\><C-n>")

;; Command mappings
(keymap.set :n "!" ":!")
(keymap.set :n ";" ":")
(keymap.set :n :U ":redo<CR>")

;; Window management
(keymap.set :n :<Leader>v ":vsp<CR>")
(keymap.set :n :<Leader>h ":sp<CR>")

;; Search and replace
(keymap.set :n :<Leader>fr ":%s/")
(keymap.set :x :<Leader>fr ":s/")

;; Visual selection behavior
(keymap.set :n :v :<C-V>)
(keymap.set :n :<C-V> :v)
(keymap.set :v :v :<C-V>)
(keymap.set :v :<C-V> :v)

;; Better indenting
(keymap.set :v "<" :<gv)
(keymap.set :v ">" :>gv)
(keymap.set :n :<Tab> ">>_")
(keymap.set :n :<S-Tab> "<<_")
(keymap.set :i :<S-Tab> :<C-D>)
(keymap.set :v :<Tab> :>gv)
(keymap.set :v :<S-Tab> :<gv)

;; Buffer navigation
(keymap.set :n :<C-Right> ":bnext<CR>")
(keymap.set :n :<C-Left> ":bprevious<CR>")
(keymap.set :n :<C-l> ":bnext<CR>")
(keymap.set :n :<C-h> ":bprevious<CR>")

;; Grep for TODOs
(keymap.set :n :<Leader>t ":GrepperRg TODO: <CR>")

(fn stripTrailingWhitespace []
  (let [pos (vim.fn.getpos ".")]
    (vim.cmd "%s/\\s\\+$//e")
    (vim.cmd "%s/\\n\\{3,}/\\r\\r/e")
    (vim.cmd "%s#\\($\\n\\s*\\)\\+\\%$##e")
    (vim.fn.keymap.setpos "." pos)))

;; Strip trailing whitespace
(keymap.set :n :<leader><space> stripTrailingWhitespace)

;; Define the StripTrailingWhitespace function
(vim.api.nvim_create_user_command :StripTrailingWhitespace
                                  stripTrailingWhitespace {})

