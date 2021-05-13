(module options
  {require {nvim aniseed.nvim}})

(set nvim.g.python_host_prog "/usr/bin/python2")
(set nvim.g.python3_host_prog "/usr/bin/python3")
(set nvim.g.node_host_prog "/home/igneo676/.config/npm/bin/neovim-node-host")

; Speedup vim startup by disabling python2
(set nvim.g.loaded_python_provider 0)

;; Generic Neovim configuration.
(set nvim.o.termguicolors true)
(set nvim.o.mouse "a")
(set nvim.o.updatetime 300)
(set nvim.o.ttimeoutlen 50)
(set nvim.o.timeoutlen 500)
(set nvim.o.inccommand :split)
(set nvim.o.background :dark)
(set nvim.o.scrolloff 10)
(set nvim.o.laststatus 2)

(set nvim.o.hidden true)
(set nvim.o.number true)
(set nvim.o.wrapscan true)
(set nvim.o.incsearch true)
(set nvim.o.ignorecase true)
(set nvim.o.smartcase true)
(set nvim.o.infercase true)
(set nvim.o.showmatch true)
(set nvim.o.autowrite true)

(set nvim.o.shiftround true)
(set nvim.o.magic true)
(set nvim.o.shiftround true)
(set nvim.o.autoread true)
(set nvim.o.expandtab true)
(set nvim.o.showcmd true)
(set nvim.o.undofile true)
(set nvim.o.secure true)
(set nvim.o.exrc true)
(set nvim.o.splitbelow true)
(set nvim.o.splitright true)

(set nvim.wo.number true)
(set nvim.wo.list true)
(set nvim.o.listchars "tab:»·,trail:·,nbsp:·")

(set nvim.o.shiftwidth 2)
(set nvim.o.softtabstop 2)
(set nvim.o.tabstop 2)
(set nvim.o.showtabline 2)

(set nvim.o.whichwrap (.. nvim.o.whichwrap ",<,>,h,l,[,]"))
(set nvim.o.shortmess (.. nvim.o.shortmess "cI"))

(set nvim.o.diffopt (.. nvim.o.diffopt ",vertical"))
(set nvim.o.tags (.. nvim.o.tags ".tags,./tags,tags;"))
(set nvim.o.clipboard "unnamedplus")
(set nvim.o.wildignore "*/log/*,*/.git/*,**/*.pyc")

(nvim.ex.set :nowb)
(nvim.ex.set :nofoldenable)
(nvim.ex.set :noshowmode)
(nvim.ex.set :termguicolors)
(nvim.ex.set :noswapfile)
(nvim.ex.set :nobackup)

(when (nvim.fn.executable "rg")
  (set nvim.o.grepprg "rg --vimgrep --no-heading")
  (set nvim.o.grepformat "%f:%l:%c:%m,%f:%l:%m"))

;; File specific settings, which I might pull out into their own module
(nvim.ex.autocmd "BufNewFile,BufRead" "*.tsx" "set filetype=typescript.tsx")
(nvim.ex.autocmd "BufNewFile,BufRead" ".eslintrc" "set filetype=json")

(nvim.ex.autocmd :FileType :gitcommit "setlocal textwidth=72")
(nvim.ex.autocmd :FileType :gitcommit "setlocal spell")

(nvim.ex.autocmd :FileType :kotlin "setlocal shiftwidth=4")
(nvim.ex.autocmd :FileType :kotlin "setlocal softtabstop=4")
(nvim.ex.autocmd :FileType :kotlin "setlocal tabstop=4")
