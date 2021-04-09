(module dotfiles.module.core
  {require {nvim aniseed.nvim
            au zest.au
            z zest.lib}
   require-macros [zest.macros]})

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

(nvim.ex.autocmd :BufWritePost :init.vim "so $MYVIMRC")
(nvim.ex.autocmd :VimResized ":windcmd =")
(nvim.ex.autocmd :FocusGained :* ":checktime")
(nvim.ex.autocmd :TextYankPost :* "lua vim.highlight.on_yank { higroup=\"IncSearch\", timeout=100}")

;; Restore previous cursor permission
(au- [BufReadPost] *
     #(nvim.fn.setpos "." (nvim.fn.getpos "'\"")))

(nvim.ex.autocmd :FileType :kotlin "setlocal shiftwidth=4")
(nvim.ex.autocmd :FileType :kotlin "setlocal softtabstop=4")
(nvim.ex.autocmd :FileType :kotlin "setlocal tabstop=4")

(when (nvim.fn.executable "rg")
  (set nvim.o.grepprg "rg --vimgrep --no-heading")
  (set nvim.o.grepformat "%f:%l:%c:%m,%f:%l:%m"))
