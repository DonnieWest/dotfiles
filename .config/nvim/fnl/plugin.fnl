(module plugin
  {require {nvim aniseed.nvim
            a aniseed.core
            util util
            packer packer}})

(defn- use [...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (let [pkgs [...]]
    (packer.startup
      (fn [use]
        (for [i 1 (a.count pkgs) 2]
          (let [name (. pkgs i)
                opts (. pkgs (+ i 1))]
            (use (a.assoc opts 1 name))))))))

;; Plugins to be managed by packer.
(use
  ;; Manage Packer w/ Packer
  :wbthomason/packer.nvim {}

  ;; Generic Plugins
  :tpope/vim-repeat {}
  :tpope/vim-surround {}
  :tpope/vim-dispatch {}
  :radenling/vim-dispatch-neovim {}
  :tpope/vim-tbone {}
  :duggiefresh/vim-easydir {}
  :tpope/vim-eunuch {}
  :tpope/vim-endwise {}
  :tpope/vim-abolish {}
  :tpope/vim-projectionist {}
  :jiangmiao/auto-pairs {}
  :windwp/nvim-ts-autotag {}
  :junegunn/vim-easy-align {}
  :ggandor/lightspeed.nvim {}

  ;; VIM Quirks fixes
  :lervag/file-line {}
  :pbrisbin/vim-mkdir {}
  :mhinz/vim-sayonara {:command "Sayonara"}
  :romainl/vim-qf {}
  :eugen0329/vim-esearch {}
  :ynkdir/vim-vimlparser {}
  :tpope/vim-unimpaired {}
  :airblade/vim-rooter {}
  :christoomey/vim-tmux-navigator {}
  :Valloric/ListToggle {}
  :Yggdroot/indentLine {}
  :pgdouyon/vim-evanesco {}
  :kana/vim-operator-user {}
  :kshenoy/vim-signature {}

  ;; UI
  :blueyed/vim-diminactive {}
  :whatyouhide/vim-gotham {}
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"}
  :nvim-treesitter/nvim-treesitter-textobjects {}
  :p00f/nvim-ts-rainbow {}
  :nvim-treesitter/nvim-treesitter-refactor {}
  :mhinz/vim-startify {}
  :itchyny/lightline.vim {}
  :mgee/lightline-bufferline {}
  :maximbaz/lightline-ale {}
  :justinmk/nvim-repl {}
  :christoomey/vim-run-interactive {}
  :ryanoasis/vim-devicons {}
  :yamatsum/nvim-web-nonicons {}
  :kyazdani42/nvim-web-devicons {}
  :folke/todo-comments.nvim {}

  :norcalli/nvim.lua {}
  :DonnieWest/nvim-base16.lua {}

  :folke/lsp-colors.nvim {}

  ;; Generic IDE features

  :rhysd/clever-f.vim {}
  :tomtom/tcomment_vim {}
  :mbbill/undotree {}
  :justinmk/vim-dirvish {}

  :hrsh7th/nvim-compe {}
  :mfussenegger/nvim-dap {}

  :kassio/neoterm {}
  :ludovicchabant/vim-gutentags {}

  :nvim-lua/popup.nvim {}
  :nvim-lua/plenary.nvim {}
  :junegunn/fzf.vim {}
  :junegunn/fzf {}

  :mhinz/vim-grepper {}
  :dense-analysis/ale {}

  :editorconfig/editorconfig-vim {}
  :justinmk/vim-gtfo {}
  :liuchengxu/vista.vim {}

  ;; LSP Features

  :neovim/nvim-lspconfig {}
  :nvim-lua/lsp-status.nvim {}
  :tjdevries/lsp_extensions.nvim {}
  :onsails/lspkind-nvim {}
  :RishabhRD/popfix {}
  :RishabhRD/nvim-lsputils {}
  :kosayoda/nvim-lightbulb {}

  ;; Appearance

  :norcalli/nvim-colorizer.lua {}
  :Firef0x/PKGBUILD.vim {}
  :ekalinin/Dockerfile.vim {}

  ;; Formatters
  :sbdchd/neoformat {}

  ;; Git plugins
  :sindrets/diffview.nvim {}
  :TimUntersberger/neogit {:requires :nvim-lua/plenary.nvim}
  :lewis6991/gitsigns.nvim {:requires :nvim-lua/plenary.nvim}
  :tpope/vim-fugitive {}
  :christoomey/vim-conflicted {}
  :ruifm/gitlinker.nvim {:requires :nvim-lua/plenary.nvim}

  ;; HTML and CSS Plugins
  :hail2u/vim-css3-syntax {}
  :othree/html5.vim {}

  ;; Javascript Plugins
  :pangloss/vim-javascript {}
  :maxmellon/vim-jsx-pretty {}
  :jparise/vim-graphql {}
  :jose-elias-alvarez/nvim-lsp-ts-utils {}
  :styled-components/vim-styled-components {:branch "main"}
  :mvolkmann/vim-react {}
  :benjie/local-npm-bin.vim {}
  :Quramy/vim-js-pretty-template {}

  ;; Typescript
  :leafgarland/typescript-vim {}
  :peitalin/vim-jsx-typescript {}

  ;; Java/Android/Gradle plugins
  :georgewfraser/java-language-server {:run "./scripts/link_mac.sh"}

  ;; Kotlin
  :donniewest/kotlin-vim {}
  :fwcd/kotlin-language-server {:run "./gradlew :server:installDist"}

  ;; Markdown/Octopress Plugins

  :rhysd/vim-grammarous {}
  :jxnblk/vim-mdx-js {}
  :gabrielelana/vim-markdown {}

  ;; Go Plugins
  :fatih/vim-go {}

  ;; SQL
  :tpope/vim-dadbod {}
  :kristijanhusak/vim-dadbod-completion {}
  :kristijanhusak/vim-dadbod-ui {}

  ;; Clojure
  :guns/vim-sexp {}
  :tpope/vim-sexp-mappings-for-regular-people {}

  :Olical/conjure {:tag "v4.21.0"}
  :dmac/vim-cljfmt {}

  :clojure-vim/clojure.vim {}
  :clojure-vim/vim-jack-in {}
  :clojure-vim/async-clj-highlight {}
  :eraserhd/parinfer-rust {:run "cargo build --release"}


  ;; Fennel
  :Olical/aniseed {:tag "v3.19.0"}
  :Olical/fennel.vim {}
  :elkowar/nvim-gehzu {}

  ;; Hy
  :hylang/vim-hy {})

;; Plugin configuration that should be loaded even if the directory doesn't
;; exist or it isn't installed according to packer.
(def- always-load
  {:aniseed true
   :gehzu true
   :fzf true
   :todo-comments true
   :gitlinker true
   :gitsigns true
   :conjure true})

(def- packer-dir (.. (nvim.fn.stdpath :data) "/site/pack/packer"))

(defn- plugin-installed? [name]
  "Checks if the plugin directory can be found in the data directory."
  (or (= 1 (nvim.fn.isdirectory (.. packer-dir "/start/" name)))
      (= 1 (nvim.fn.isdirectory (.. packer-dir "/opt/" name)))))

(defn- find-plugin [candidate]
  "Returns the matching plugin name if the given plugin can be found within any
  of the required plugins So `deoplete` would match `deoplete.nvim`."
  (let [plugins (a.get _G :packer_plugins)]
    (or (and (a.get plugins candidate) candidate)
        (->> (a.keys plugins)
             (a.some
               (fn [plug-name]
                 (and (plug-name:find candidate 1 true) plug-name)))))))

;; Load plugin configuration modules.
(a.run!
  (fn [path]
    (let [name (nvim.fn.fnamemodify path ":t:r")
          full-name (find-plugin name)
          bypass? (. always-load name)]
      (if (or bypass? full-name)
        (if (or bypass? (plugin-installed? full-name))
          (match (pcall require (.. "plugin." name))
            (false err) (print "Error requiring plugin module:" name "-" err))
          (print (.. "Not loading plugin module, not installed yet: " name)))
        (print (.. "Orphan plugin configuration: " name)))))
  (util.glob (.. (nvim.fn.stdpath "config") "/lua/plugin/*.lua")))
