" Install Vim Plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
let g:node_host_prog = '/home/igneo676/.config/npm/bin/neovim-node-host'

call plug#begin()

"Generic Plugins
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
Plug 'tpope/vim-tbone'
Plug 'duggiefresh/vim-easydir'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-projectionist'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'phaazon/hop.nvim' " Easymotion / sneak alternative?

" VIM Quirks fixes
Plug 'lervag/file-line'
Plug 'pbrisbin/vim-mkdir'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'romainl/vim-qf'
Plug 'eugen0329/vim-esearch'
Plug 'ynkdir/vim-vimlparser'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-rooter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Valloric/ListToggle'
Plug 'Yggdroot/indentLine'
Plug 'pgdouyon/vim-evanesco'
Plug 'kana/vim-operator-user'
Plug 'kshenoy/vim-signature'
Plug 'Firef0x/PKGBUILD.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'blueyed/vim-diminactive'

" UI
Plug 'whatyouhide/vim-gotham'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'mgee/lightline-bufferline'
Plug 'maximbaz/lightline-ale'
Plug 'justinmk/nvim-repl'
Plug 'christoomey/vim-run-interactive'
Plug 'axvr/photon.vim'

Plug 'norcalli/nvim.lua'
Plug 'norcalli/nvim-base16.lua'

" Generic IDE features

Plug 'simnalamburt/vim-mundo'
Plug 'rhysd/clever-f.vim'
Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree'
Plug 'justinmk/vim-dirvish'

Plug 'hrsh7th/nvim-compe'
" Plug 'puremourning/vimspector'
Plug 'mfussenegger/nvim-dap'

Plug 'kassio/neoterm'
Plug 'ludovicchabant/vim-gutentags'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

Plug 'mhinz/vim-grepper'
Plug 'dense-analysis/ale'

Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-gtfo'
Plug 'liuchengxu/vista.vim'

" LSP Features

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'
Plug 'kosayoda/nvim-lightbulb'

" Appearance

Plug 'norcalli/nvim-colorizer.lua'

" Formatters
Plug 'sbdchd/neoformat'

"Git plugins
Plug 'TimUntersberger/neogit'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-conflicted'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-rhubarb'
"vim-rhubarb variables set in ~/.rhubarb_credentials

"HTML and CSS Plugins
Plug 'hail2u/vim-css3-syntax'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim'
Plug 'AndrewRadev/tagalong.vim'

"Javascript Plugins
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'alampros/vim-react-keywords'
Plug 'jparise/vim-graphql'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'mvolkmann/vim-react'
Plug 'mvolkmann/vim-js-arrow-function'
Plug 'PsychoLlama/further.vim'
Plug 'benjie/local-npm-bin.vim'
Plug 'Quramy/vim-js-pretty-template'

" Typescript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Reason
Plug 'reasonml-editor/vim-reason-plus'

"Java/Android/Gradle plugins
Plug 'georgewfraser/java-language-server', { 'do': './scripts/link_mac.sh' }

" Kotlin
Plug 'donniewest/kotlin-vim'
Plug 'fwcd/kotlin-language-server', { 'do': './gradlew :server:installDist' }

"VIMScript Plugins
Plug 'machakann/vim-Verdin'

"Markdown/Octopress Plugins

Plug 'rhysd/vim-grammarous'
Plug 'junegunn/goyo.vim'
Plug 'jxnblk/vim-mdx-js'
Plug 'gabrielelana/vim-markdown'

" Go Plugins
Plug 'fatih/vim-go'

" SQL
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'

" Clojure
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

Plug 'Olical/conjure', {'tag': 'v4.17.0'}
Plug 'dmac/vim-cljfmt'

Plug 'clojure-vim/clojure.vim'
Plug 'clojure-vim/vim-jack-in'
Plug 'clojure-vim/async-clj-highlight'


" Fennel
Plug 'Olical/aniseed', { 'tag': 'v3.16.0' }
Plug 'bakpakin/fennel.vim'

" Hy
Plug 'hylang/vim-hy'

call plug#end()

let g:aniseed#env = v:true

