;; Host programs for external language support
(set vim.g.python_host_prog "/usr/bin/python2")
(set vim.g.python3_host_prog "/usr/bin/python3")
(set vim.g.node_host_prog "~/.config/npm/bin/neovim-node-host")

;; Disable unnecessary providers for faster startup
(set vim.g.loaded_python_provider 0)

;; Enable Tree-sitter highlighting for Lua
(set vim.g.ts_highlight_lua true)

(local opt vim.opt)
(set opt.inccommand :split)
(set opt.smartcase true)
(set opt.ignorecase true)
(set opt.number true)
(set opt.splitbelow true)
(set opt.splitright true)
(set opt.signcolumn :yes)
(set opt.shada ["'10" :<0 :s10 :h])
(set opt.swapfile false)
(opt.formatoptions:remove :o)
(set opt.wrap true)
(set opt.linebreak true)
(set opt.tabstop 4)
(set opt.shiftwidth 4)
(set opt.more false)
(set opt.foldmethod :manual)

;; General settings
(set opt.termguicolors true)
(set opt.mouse "a")
(set opt.updatetime 300)
(set opt.ttimeoutlen 50)
(set opt.timeoutlen 500)
(set opt.inccommand "split")
(set opt.background "dark")
(set opt.scrolloff 10)
(set opt.laststatus 2)
(set opt.hidden true)
(set opt.number true)
(set opt.wrapscan true)
(set opt.incsearch true)
(set opt.ignorecase true)
(set opt.smartcase true)
(set opt.infercase true)
(set opt.showmatch true)
(set opt.autowrite true)
(set opt.shiftround true)
(set opt.magic true)
(set opt.autoread true)
(set opt.expandtab true)
(set opt.showcmd true)
(set opt.undofile true)
(set opt.secure true)
(set opt.exrc true)
(set opt.splitbelow true)
(set opt.splitright true)

;; Window-local settings
(set vim.w.number true)
(set vim.w.list true)

;; List characters and indentation
(set vim.o.listchars "tab:»·,trail:·,nbsp:·")
(set opt.shiftwidth 2)
(set opt.softtabstop 2)
(set opt.tabstop 2)
(set opt.showtabline 2)

;; Enhanced navigation and formatting
(set vim.o.whichwrap (.. vim.o.whichwrap ",<,>,h,l,[,]"))
(set vim.o.shortmess (.. vim.o.shortmess "cI"))
(set vim.o.diffopt (.. vim.o.diffopt ",vertical"))
(set vim.o.tags (.. vim.o.tags ".tags,./tags,tags;"))
(set opt.clipboard "unnamedplus")
(set vim.o.wildignore "*/log/*,*/.git/*,**/*.pyc")

;; Disable unnecessary features
(vim.cmd "set nowb")
(vim.cmd "set nofoldenable")
(vim.cmd "set noshowmode")
(vim.cmd "set nobackup")

;; Use ripgrep if available
(when (> (vim.fn.executable "rg") 0)
  (set vim.opt.grepprg "rg --vimgrep --no-heading")
  (set vim.opt.grepformat "%f:%l:%c:%m,%f:%l:%m"))

;; Filetype-specific settings
(vim.cmd "autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx")
(vim.cmd "autocmd BufNewFile,BufRead .eslintrc set filetype=json")
(vim.cmd "autocmd FileType gitcommit setlocal textwidth=72 spell")
(vim.cmd "autocmd FileType kotlin setlocal shiftwidth=4 softtabstop=4 tabstop=4")
(vim.cmd "autocmd FileType markdown setlocal spell wrap linebreak")
