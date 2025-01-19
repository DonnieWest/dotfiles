local _2afile_2a = "/home/igneo676/.config/nvim/fnl/options.fnl"
local _2amodule_name_2a = "options"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local nvim = require("aniseed.nvim")
do end (_2amodule_locals_2a)["nvim"] = nvim
nvim.g.python_host_prog = "/usr/bin/python2"
nvim.g.python3_host_prog = "/usr/bin/python3"
nvim.g.node_host_prog = "/home/igneo676/.config/npm/bin/neovim-node-host"
nvim.g.loaded_python_provider = 0
nvim.g.ts_highlight_lua = true
nvim.o.termguicolors = true
nvim.o.mouse = "a"
nvim.o.updatetime = 300
nvim.o.ttimeoutlen = 50
nvim.o.timeoutlen = 500
nvim.o.inccommand = "split"
nvim.o.background = "dark"
nvim.o.scrolloff = 10
nvim.o.laststatus = 2
nvim.o.hidden = true
nvim.o.number = true
nvim.o.wrapscan = true
nvim.o.incsearch = true
nvim.o.ignorecase = true
nvim.o.smartcase = true
nvim.o.infercase = true
nvim.o.showmatch = true
nvim.o.autowrite = true
nvim.o.shiftround = true
nvim.o.magic = true
nvim.o.shiftround = true
nvim.o.autoread = true
nvim.o.expandtab = true
nvim.o.showcmd = true
nvim.o.undofile = true
nvim.o.secure = true
nvim.o.exrc = true
nvim.o.splitbelow = true
nvim.o.splitright = true
nvim.wo.number = true
nvim.wo.list = true
nvim.o.listchars = "tab:\194\187\194\183,trail:\194\183,nbsp:\194\183"
nvim.o.shiftwidth = 2
nvim.o.softtabstop = 2
nvim.o.tabstop = 2
nvim.o.showtabline = 2
nvim.o.whichwrap = (nvim.o.whichwrap .. ",<,>,h,l,[,]")
nvim.o.shortmess = (nvim.o.shortmess .. "cI")
nvim.o.diffopt = (nvim.o.diffopt .. ",vertical")
nvim.o.tags = (nvim.o.tags .. ".tags,./tags,tags;")
nvim.o.clipboard = "unnamedplus"
nvim.o.wildignore = "*/log/*,*/.git/*,**/*.pyc"
nvim.ex.set("nowb")
nvim.ex.set("nofoldenable")
nvim.ex.set("noshowmode")
nvim.ex.set("termguicolors")
nvim.ex.set("noswapfile")
nvim.ex.set("nobackup")
if nvim.fn.executable("rg") then
  nvim.o.grepprg = "rg --vimgrep --no-heading"
  nvim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
else
end
nvim.ex.autocmd("BufNewFile,BufRead", "*.tsx", "set filetype=typescript.tsx")
nvim.ex.autocmd("BufNewFile,BufRead", ".eslintrc", "set filetype=json")
nvim.ex.autocmd("FileType", "gitcommit", "setlocal textwidth=72")
nvim.ex.autocmd("FileType", "gitcommit", "setlocal spell")
nvim.ex.autocmd("FileType", "kotlin", "setlocal shiftwidth=4")
nvim.ex.autocmd("FileType", "kotlin", "setlocal softtabstop=4")
nvim.ex.autocmd("FileType", "kotlin", "setlocal tabstop=4")
nvim.ex.autocmd("FileType", "markdown", "setlocal spell")
nvim.ex.autocmd("FileType", "markdown", "setlocal wrap linebreak")
return _2amodule_2a