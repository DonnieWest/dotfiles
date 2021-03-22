" Install Vim Plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
let g:node_host_prog = '/home/igneo676/bin/neovim-node-host'

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
Plug 'idanarye/vim-vebugger', { 'branch': 'develop' }
Plug 'justinmk/vim-sneak'

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
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Valloric/ListToggle'
Plug 'Yggdroot/indentLine'
Plug 'pgdouyon/vim-evanesco'
Plug 'kana/vim-operator-user'
Plug 'kshenoy/vim-signature'
Plug 'Firef0x/PKGBUILD.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'blueyed/vim-diminactive'
Plug 'keith/swift.vim'

" UI
Plug 'whatyouhide/vim-gotham'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'mhartington/oceanic-next'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'mgee/lightline-bufferline'
Plug 'maximbaz/lightline-ale'
Plug 'haishanh/night-owl.vim'
" Plug 'edkolev/tmuxline.vim'
Plug 'luochen1990/rainbow'
Plug 'chrisbra/Colorizer'
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
Plug 'mg979/vim-visual-multi'

Plug 'LeafCage/echos.vim'

Plug 'hrsh7th/nvim-compe'
Plug 'prabirshrestha/async.vim'
Plug 'kristijanhusak/vim-carbon-now-sh'
" Plug 'puremourning/vimspector'
Plug 'mfussenegger/nvim-dap'

Plug 'Shougo/context_filetype.vim'
Plug 'kassio/neoterm'
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

Plug 'mhinz/vim-grepper'
Plug 'dense-analysis/ale'
Plug 'metakirby5/codi.vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-gtfo'
Plug 'sunaku/vim-dasht'
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vista.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'
Plug 'kosayoda/nvim-lightbulb'

" Appearance

Plug 'thiagoalessio/rainbow_levels.vim'
Plug 'norcalli/nvim-colorizer.lua'

" Formatters
Plug 'sbdchd/neoformat'

"Git plugins
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-conflicted'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-rhubarb'
Plug 'lambdalisue/gina.vim'
"vim-rhubarb variables set in ~/.rhubarb_credentials

"HTML and CSS Plugins
Plug 'hail2u/vim-css3-syntax'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim'
Plug 'AndrewRadev/tagalong.vim'

"Javascript Plugins
Plug 'jungomi/vim-mdnquery'
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

" C# Based Plugins
Plug 'OmniSharp/omnisharp-vim'
Plug 'nickspoons/vim-sharpenup'

" Go Plugins
Plug 'fatih/vim-go'

" SQL
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'

" Clojure
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

Plug 'Olical/conjure', {'tag': 'v4.15.0'}
Plug 'dmac/vim-cljfmt'

Plug 'tami5/compe-conjure'

Plug 'clojure-vim/clojure.vim'
Plug 'clojure-vim/vim-jack-in'
Plug 'clojure-vim/async-clj-highlight'
Plug 'luochen1990/rainbow'


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
let mapleader=","
nnoremap U :redo<cr>
set undodir=~/.vim/undodir
set shortmess+=cI
set diffopt+=vertical
nnoremap ! :!
nnoremap ; :
set tags=.tags,./tags,tags;
set list listchars=tab:»·,trail:·,nbsp:·
"Generic wildignores
set wildignore+=*/log/*,*/.git/*,**/*.pyc

augroup dirvish_config
  autocmd!
  autocmd FileType dirvish silent! unmap <buffer> <C-p>
  autocmd FileType dirvish silent! unmap <buffer> <C-n>
augroup END

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"Set IndentLines to disabled by default
let g:indentLine_enabled = 0

" Allow gitgutter on large files
let g:gitgutter_max_signs=10000
let g:magit_discard_untracked_do_delete=1
let g:magit_refresh_gitgutter=1
autocmd BufWritePost * :GitGutter
autocmd User ALELintPost :GitGutter
autocmd User VimagitLeaveCommit :GitGutterAll
autocmd User VimagitUpdateFile :GitGutterAll

let g:closetag_xhtml_filenames = '*.xhtml,*.js,*.tsx'

" This will make the list of non closing tags case sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'


autocmd FileType clojure nnoremap <silent> gd    <cmd>:ConjureDefWord<CR>
autocmd FileType clojure nnoremap <silent> <c-]> <cmd>:ConjureDefWord<CR>
autocmd FileType clojure nnoremap <silent> K     <cmd>:ConjureDocWord<CR>
autocmd FileType clojure nnoremap <silent> gD    <cmd>:ConjureCljViewSource<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

nnoremap <silent> gk :call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>
let g:dasht_filetype_docsets = {} " filetype => list of docset name regexp
let g:dasht_filetype_docsets['javascript'] = ['React', 'React_Native', 'Sequelize']
let g:dasht_filetype_docsets['kotlin'] = ['Android']

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

" Split window Vertically
nmap <leader>v :vsp<cr>
" Split window horizontally
nmap <leader>h :sp<cr>

"Make visual selection more sane
nnoremap    v   <C-V>
nnoremap <C-V>     v

vnoremap    v   <C-V>
vnoremap <C-V>     v

"Better indent
vnoremap < <gv
vnoremap > >gv

"Disable Ex mode
map Q <Nop>

"Ctrl + Left and Right switch buffers
nnoremap <silent> <C-Right> :bnext<CR>
nnoremap <silent> <C-Left> :bprevious<CR>
nnoremap <silent> <C-Del> :Sayonara<CR>

let g:startify_custom_header = []
let g:startify_change_to_vcs_root = 1

let g:qf_auto_open_loclist = 0

let g:esearch = {
  \ 'adapter':    'rg',
  \ 'backend':    'nvim',
  \ 'out':        'win',
  \ 'batch_size': 1000,
  \ 'use':        ['visual', 'hlsearch', 'last'],
  \}

nnoremap <C-p> :lua require'telescope.builtin'.find_files{}<ENTER>
if has('nvim')
  aug fzf_setup
    au!
    au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
  aug END
end

runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' -i'
nnoremap \ :GrepperRg 

" Map ,t to search for my Todos
map <LEADER>t :GrepperRg TODO: <CR>

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

nnoremap <Leader>fr :%s/
xnoremap <Leader>fr :s/
call esearch#map('<leader>ff', 'esearch')
call esearch#map('<leader>fw', 'esearch-word-under-cursor')
hi ESearchMatch ctermfg=black ctermbg=white guifg=#000000 guibg=#E6E6FA

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

set showtabline=2

let g:sharpenup_statusline_opts = { 'Highlight': 0 }

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

function! LspStatus() abort
  let status = luaeval('require("lsp-status").status()')
  return trim(status)
endfunction

let g:lightline = {
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'colorscheme': 'gotham256',
      \ 'tabline': {
      \   'left': [['buffers']],
      \   'right': [[ 'exit' ]],
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'method'] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              ['gradle_project', 'gradle_running', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok'],
      \              [ 'lsp_status' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ],
      \              ['sharpenup']
      \            ]
      \ },
      \ 'inactive': {
      \   'right': [['lineinfo'], ['percent'], ['sharpenup'], ['lsp_status']]
      \ },
      \ 'component': {
      \   'sharpenup': sharpenup#statusline#Build()
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'method': 'NearestMethodOrFunction',
      \   'lsp_status': 'LspStatus'
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers',
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \   'gradle_errors': 'lightline#gradle#errors',
      \   'gradle_warnings': 'lightline#gradle#warnings',
      \   'gradle_running': 'lightline#gradle#running',
      \   'gradle_project': 'lightline#gradle#project'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel',
      \   'gradle_errors': 'error',
      \   'gradle_warnings': 'warning',
      \   'gradle_running': 'left',
      \   'gradle_project': 'right',
      \   'linter_checking': 'left',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'left'
      \ },
      \ }

autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx


nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <Leader>r <cmd>lua vim.lsp.buf.rename()<CR>

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

let g:vim_json_syntax_conceal = 0
" Python Stuff
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

" Javascript Stuff
let g:jsx_ext_required = 0
let g:mustache_abbreviations = 1
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

" Fetch semantic type/interface/identifier names on BufEnter and highlight them
let g:OmniSharp_highlight_types = 1
let g:OmniSharp_server_stdio = 1

let g:sharpenup_create_mappings = 0

augroup lightline_integration
  autocmd!
  autocmd User OmniSharpStarted,OmniSharpReady,OmniSharpStopped call lightline#update()
augroup END

augroup omnisharp_commands
    autocmd!

    " When Syntastic is available but not ALE, automatic syntax check on events
    " (TextChanged requires Vim 7.4)
    " autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " Update the highlighting whenever leaving insert mode
    autocmd InsertLeave *.cs call OmniSharp#HighlightBuffer()

    " Alternatively, use a mapping to refresh highlighting for the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>th :OmniSharpHighlightTypes<CR>

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    " autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>


    autocmd FileType cs " Rename with dialog
    autocmd FileType cs nnoremap <F2> :OmniSharpRename<CR>
    " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
    autocmd FileType cs command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    autocmd FileType cs nnoremap <Leader>fm :OmniSharpCodeFormat<CR>

    " Start the omnisharp server for the current solution
    autocmd FileType cs nnoremap <Leader>ss :OmniSharpStartServer<CR>
    autocmd FileType cs nnoremap <Leader>sp :OmniSharpStopServer<CR>



augroup END


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

"XML completion based on CTags
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let java_highlight_functions = 'style'
let java_highlight_all = 1
let java_highlight_debug = 1

let g:rainbow_levels = [
    \{'ctermbg': 232, 'guibg': '#080808'},
    \{'ctermbg': 233, 'guibg': '#121212'},
    \{'ctermbg': 234, 'guibg': '#1c1c1c'},
    \{'ctermbg': 235, 'guibg': '#262626'},
    \{'ctermbg': 236, 'guibg': '#303030'},
    \{'ctermbg': 237, 'guibg': '#3a3a3a'},
    \{'ctermbg': 238, 'guibg': '#444444'},
    \{'ctermbg': 239, 'guibg': '#4e4e4e'},
    \{'ctermbg': 240, 'guibg': '#585858'}]


" vim-visual-multi configuration
let g:VM_default_mappings           = 1
let g:VM_sublime_mappings           = 0
let g:VM_mouse_mappings             = 1
let g:VM_extended_mappings          = 0
let g:VM_no_meta_mappings           = 0
let g:VM_reselect_first_insert      = 0
let g:VM_reselect_first_always      = 0
let g:VM_case_setting               = "smart"
let g:VM_pick_first_after_n_cursors = 0
let g:VM_dynamic_synmaxcol          = 20
let g:VM_disable_syntax_in_imode    = 0
let g:VM_exit_on_1_cursor_left      = 0
let g:VM_manual_infoline            = 0

" Wayland clipboard provider that strips carriage returns (GTK3 issue).
" This is needed because currently there's an issue where GTK3 applications on
" Wayland contain carriage returns at the end of the lines (this is a root
" issue that needs to be fixed).
let g:clipboard = {
      \   'name': 'wayland-strip-carriage',
      \   'copy': {
      \      '+': 'wl-copy --foreground --type text/plain',
      \      '*': 'wl-copy --foreground --type text/plain --primary',
      \    },
      \   'paste': {
      \      '+': {-> systemlist('wl-paste | tr -d "\r"')},
      \      '*': {-> systemlist('wl-paste --primary | tr -d "\r"')},
      \   },
      \   'cache_enabled': 1,
      \ }

let g:diagnostic_insert_delay = 1
let g:diagnostic_enable_virtual_text = 1

autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }

lua << EOF
local nvim_lsp = require'lspconfig'
local nvim_command = vim.api.nvim_command
local lsp_status = require('lsp-status')

vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

nvim_lsp.jsonls.setup{
  on_attach = on_attach;
  settings = {
    json = {
      schemas = {
        {
          description = 'TypeScript compiler configuration file',
          fileMatch = {'tsconfig.json', 'tsconfig.*.json'},
          url = 'http://json.schemastore.org/tsconfig'
        },
        {
          description = 'NPM package.json',
          fileMatch = {'package.json'},
          url = 'http://json.schemastore.org/package'
        },
        {
          description = 'Lerna config',
          fileMatch = {'lerna.json'},
          url = 'http://json.schemastore.org/lerna'
        },
        {
          description = 'Babel configuration',
          fileMatch = {'.babelrc.json', '.babelrc', 'babel.config.json'},
          url = 'http://json.schemastore.org/lerna'
        },
        {
          description = 'ESLint config',
          fileMatch = {'.eslintrc.json', '.eslintrc'},
          url = 'http://json.schemastore.org/eslintrc'
        },
        {
          description = 'Bucklescript config',
          fileMatch = {'bsconfig.json'},
          url = 'https://bucklescript.github.io/bucklescript/docson/build-schema.json'
        },
        {
          description = 'Prettier config',
          fileMatch = {'.prettierrc', '.prettierrc.json', 'prettier.config.json'},
          url = 'http://json.schemastore.org/prettierrc'
        }
      };
    };
    jsonls = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true;
          };
        };
      };
    };
  }
}

nvim_lsp.kotlin_language_server.setup{
  cmd = { "/home/igneo676/.config/nvim/plugged/kotlin-language-server/server/build/install/server/bin/kotlin-language-server" };
  log_level = vim.lsp.protocol.MessageType.Log;
  root_dir = nvim_lsp.util.root_pattern("settings.gradle.kts") or nvim_lsp.util.root_pattern("settings.gradle");
  message_level = vim.lsp.protocol.MessageType.Log;
  on_attach = on_attach;
  settings = {
    kotlin = {
      compiler = {
        jvm = {
          target = "1.8";
        }
      };
    };
  }
}
EOF
