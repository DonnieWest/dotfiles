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
Plug 'luochen1990/rainbow'
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
Plug 'samuelsimoes/vim-jsx-utils'
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
Plug 'hsanson/vim-android'
Plug 'npacker/vim-java-syntax-after'
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

" C Based plugins
Plug 'justinmk/vim-syntax-extra'

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

Plug 'tami5/compe-conjure'

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

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set shiftwidth=2
set softtabstop=2
set tabstop=2
set whichwrap+=<,>,h,l,[,]
set undodir=~/.vim/undodir
set shortmess+=cI
set diffopt+=vertical
set tags=.tags,./tags,tags;
set list listchars=tab:»·,trail:·,nbsp:·
"Generic wildignores
set wildignore+=*/log/*,*/.git/*,**/*.pyc
set showtabline=2

augroup dirvish_config
  autocmd!
  autocmd FileType dirvish silent! unmap <buffer> <C-p>
  autocmd FileType dirvish silent! unmap <buffer> <C-n>
augroup END

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"Set IndentLines to disabled by default
let g:indentLine_enabled = 0

let g:closetag_xhtml_filenames = '*.xhtml,*.js,*.tsx'

" This will make the list of non closing tags case sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Use RipGrep instead of Grep
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

let g:rainbow_active = 1
let g:incsearch#auto_nohlsearch = 1
let g:asterisk#keeppos = 1
let g:ag_working_path_mode="r"
"Use unix clipboard
set clipboard+=unnamedplus

nnoremap <silent> <C-Del> :Sayonara<CR>

let g:startify_custom_header = []
let g:startify_change_to_vcs_root = 1

let g:qf_auto_open_loclist = 0

runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' -i'
nnoremap \ :GrepperRg 

" Automatically resize quickfix window to contents
au FileType qf call AdjustWindowHeight(3, 15)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

"Automatically go back to where you were last editing this file
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" |
  \ endif

tnoremap <Esc> <C-\><C-n>

autocmd User Startified setlocal buftype=
let g:startify_bookmarks = [
            \ { 'c': '~/.config/nvim/init.vim' },
            \ ]

let g:tmux_navigator_no_mappings = 1


tnoremap <silent> <M-Left> <C-\><C-n>:TmuxNavigateLeft<cr>
tnoremap <silent> <M-Down> <C-\><C-n>:TmuxNavigateDown<cr>
tnoremap <silent> <M-Up> <C-\><C-n>:TmuxNavigateUp<cr>
tnoremap <silent> <M-Right> <C-\><C-n>:TmuxNavigateRight<cr>
" These mappings are used when nvim IS inside tmux
tnoremap <silent> <C-W>k    <C-\><C-n>:TmuxNavigateUp<CR>
tnoremap <silent> <C-W>j    <C-\><C-n>:TmuxNavigateDown<CR>
tnoremap <silent> <C-W>h    <C-\><C-n>:TmuxNavigateLeft<CR>
tnoremap <silent> <C-W>l    <C-\><C-n>:TmuxNavigateRight<CR>

nnoremap <silent> <M-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <Alt-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <M-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <M-Right> :TmuxNavigateRight<cr>
" These mappings are used when nvim IS inside tmux
nnoremap <silent> <C-W>k    :TmuxNavigateUp<CR>
nnoremap <silent> <C-W>j    :TmuxNavigateDown<CR>
nnoremap <silent> <C-W>h    :TmuxNavigateLeft<CR>
nnoremap <silent> <C-W>l    :TmuxNavigateRight<CR>

autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx

function! GutentagsFilter(path) abort
    if fnamemodify(a:path, ':e') == 'java'
      return 0
    elseif fnamemodify(a:path, ':e') == ''
      return 0
    elseif fnamemodify(a:path, ':e') == 'xml'
      return 0
    elseif fnamemodify(a:path, ':e') == 'gradle'
      return 0
    else
      return 1
    endif
endfunction

let g:gutentags_enabled_user_func = 'GutentagsFilter'
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_ctags_executable_php = 'ctags --langmap=php:.engine.inc.module.theme.install.php --php-kinds=cdfi --fields=+l'

" HTML/CSS/Markdown/Octopress Stuff
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css,scss,sass setlocal iskeyword+=-

" Javascript Stuff
let g:jsx_ext_required = 0
let g:mustache_abbreviations = 1
let g:vim_json_syntax_conceal = 0
autocmd BufNewFile,BufRead .eslintrc set ft=json

autocmd FileType javascript nnoremap <buffer> <F3> :TSImport<CR>
autocmd FileType javascript inoremap <buffer> <F3> :TSImport<CR>
autocmd FileType json setlocal conceallevel=0

" autocmd FileType javascript setlocal omnifunc=tsuquyomi#complete
autocmd FileType javascript nnoremap eir :call JSXEncloseReturn()<CR>
autocmd FileType javascript nnoremap oat :call JSXEachAttributeInLine()<CR>
autocmd FileType javascript nnoremap eat :call JSXExtractPartialPrompt()<CR>
autocmd FileType javascript nnoremap cat :call JSXChangeTagPrompt()<CR>
autocmd FileType javascript nnoremap vat :call JSXSelectTag()<CR>

" Register tag name associated the filetype
call jspretmpl#register_tag('gql', 'graphql')
call jspretmpl#register_tag('/* GraphQL */ ', 'graphql')
autocmd FileType javascript JsPreTmpl
autocmd FileType javascript.jsx JsPreTmpl

autocmd FileType kotlin setlocal shiftwidth=4
autocmd FileType kotlin setlocal softtabstop=4
autocmd FileType kotlin setlocal tabstop=4

" Git Stuff

" Automatically wrap at 72 characters and spell check git commit messages
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType gitcommit setlocal spell
let g:grammarous#languagetool_cmd = 'languagetool'

"VIM Android/Java/Gradle stuff
let g:android_sdk_path = expand("$ANDROID_HOME")
let g:gradle_daemon=1
let g:gradle_show_signs=0
let g:gradle_loclist_show=0
let g:gradle_sync_on_load=1

let g:gradle_glyph_error=''
let g:gradle_glyph_warning=''
let g:gradle_glyph_gradle=''
let g:gradle_glyph_android=''
let g:gradle_glyph_building=''

augroup GradleGroup
  autocmd!
  au BufWrite build.gradle call gradle#sync()
augroup END
