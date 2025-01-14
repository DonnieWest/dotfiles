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

(keymap.set :n :<Leader>c :gcc { :noremap false :silent true})

(keymap.set :v :<Leader>c :gc { :noremap false :silent true})

;; Grep for TODOs
(keymap.set :n :<Leader>t ":GrepperRg TODO: <CR>")

(fn operator-rhs []
  ((. (require :vim._comment) :operator)))
(keymap.set [:n :x] :<Leader>c operator-rhs {:desc "Toggle comment" :expr true})

(fn line-rhs []
  (.. ((. (require :vim._comment) :operator)) "_"))

(keymap.set :n :<Leader>c line-rhs {:desc "Toggle comment line" :expr true})

(fn textobject-rhs []
  ((. (require :vim._comment) :textobject)))

(keymap.set [:o] :<Leader>c textobject-rhs {:desc "Comment textobject"})

(fn stripTrailingWhitespace []
  (let [pos (vim.fn.getpos ".")]
    (vim.cmd "%s/\\s\\+$//e")
    (vim.cmd "%s/\\n\\{3,}/\\r\\r/e")
    (vim.cmd "%s#\\($\\n\\s*\\)\\+\\%$##e")
    (vim.fn.setpos "." pos)))

;; Strip trailing whitespace
(keymap.set :n :<leader><space> stripTrailingWhitespace)

;; Define the StripTrailingWhitespace function
(vim.api.nvim_create_user_command :StripTrailingWhitespace
                                  stripTrailingWhitespace {})

(vim.api.nvim_create_autocmd [:BufWritePost]
                             {:pattern :init.vim :command "source $MYVIMRC"})

(vim.api.nvim_create_autocmd [:VimResized] {:command "wincmd ="})

(vim.api.nvim_create_autocmd [:FocusGained] {:command :checktime})

(vim.api.nvim_create_autocmd [:TextYankPost]
                             {:callback #(vim.highlight.on_yank {:higroup :IncSearch
                                                                 :timeout 100})})

;; Restore previous cursor permission
(vim.api.nvim_create_autocmd [:BufReadPost]
                             {:desc "set position after vim loads"
                              :callback #(vim.fn.setpos "."
                                                         (vim.fn.getpos "'\""))})
