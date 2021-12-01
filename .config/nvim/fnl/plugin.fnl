(module plugin
  {require {nvim aniseed.nvim
            a aniseed.core
            util util
            packer packer}})

(defn- safe-require-plugin-config [name]
  "Safely require a module under the plugin.* prefix. Will catch errors
  and print them while continuing execution, allowing other plugins to load
  even if one configuration module is broken."
  (let [(ok? val-or-err) (pcall require (.. ".plugin." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn req [name]
  "A shortcut to building a require string for your plugin
  configuration. Intended for use with packer's config or setup
  configuration options. Will prefix the name with `magic.plugin.`
  before requiring."
  (.. "require('magic.plugin." name "')"))

(defn use [pkgs]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well.
  This is just a helper / syntax sugar function to make interacting with packer
  a little more concise."
  (packer.startup
    (fn [use]
      (each [name opts (pairs pkgs)]
          (-?> (. opts :mod) (safe-require-plugin-config))
          (use (a.assoc opts 1 name)))))

  nil)

;; Plugins to be managed by packer.
(use {:wbthomason/packer.nvim {} ;; Manage Packer w/ Packer

      ;; Generic Plugins
      :tpope/vim-repeat {}
      :tpope/vim-surround {}
      :tpope/vim-tbone {}
      :duggiefresh/vim-easydir {}
      :tpope/vim-eunuch {}
      :tpope/vim-endwise {}
      :tpope/vim-abolish {}
      :jiangmiao/auto-pairs {:mod :auto-pairs}
      :junegunn/vim-easy-align {:mod :easy-align}
      :ggandor/lightspeed.nvim {}

      ;; VIM Quirks fixes
      :lervag/file-line {}
      :pbrisbin/vim-mkdir {}
      :mhinz/vim-sayonara {:command "Sayonara" :mod :sayonara}
      :romainl/vim-qf {:mod :qf}
      :eugen0329/vim-esearch {}
      :airblade/vim-rooter {}
      :christoomey/vim-tmux-navigator {:mod :navigator}
      :Valloric/ListToggle {}
      :Yggdroot/indentLine {:mod :indentLine}
      :pgdouyon/vim-evanesco {}
      :kshenoy/vim-signature {}
      :antoinemadec/FixCursorHold.nvim {}
      :lewis6991/impatient.nvim {:compile_path (.. (vim.fn.stdpath :config) "/lua/packer_compiled.lua")}

      ;; UI
      :blueyed/vim-diminactive {}
      :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"}
      :nvim-treesitter/nvim-treesitter-textobjects {}
      :p00f/nvim-ts-rainbow {}
      :nvim-treesitter/nvim-treesitter-refactor {}
      :mhinz/vim-startify {:mod :startify}

      :itchyny/lightline.vim {:mod :lightline}
      :mgee/lightline-bufferline {}
      :maximbaz/lightline-ale {}
      :josa42/nvim-lightline-lsp {}

      :ryanoasis/vim-devicons {}
      :yamatsum/nvim-web-nonicons {}
      :kyazdani42/nvim-web-devicons {}
      :folke/todo-comments.nvim {:mod :todo-comments}
      :DonnieWest/nvim-base16.lua {}
      :folke/lsp-colors.nvim {}

      ;; Generic IDE features

      :rhysd/clever-f.vim {}
      :tomtom/tcomment_vim {:mod :tcomment}
      :mbbill/undotree {:mod :undotree}
      :justinmk/vim-dirvish {:mod :dirvish}

      :mfussenegger/nvim-dap {}

      :kassio/neoterm {}
      :ludovicchabant/vim-gutentags {:mod :gutentags}

      :nvim-lua/popup.nvim {}
      :nvim-lua/plenary.nvim {}
      :junegunn/fzf.vim {:mod :fzf}
      :junegunn/fzf {}

      :mhinz/vim-grepper {:mod :grepper}
      :dense-analysis/ale {:mod :ale}

      :editorconfig/editorconfig-vim {}
      :justinmk/vim-gtfo {}
      :liuchengxu/vista.vim {:mod :vista}

      ;; Completion

      :hrsh7th/nvim-cmp {:mod :cmp}
      :PaterJason/cmp-conjure {}
      :hrsh7th/cmp-nvim-lsp {}
      :hrsh7th/cmp-path {}

      :hrsh7th/cmp-vsnip {}
      :hrsh7th/vim-vsnip {}

      :rafamadriz/friendly-snippets {}

      ;; LSP Features

      :neovim/nvim-lspconfig {:mod :lsp}
      :tjdevries/lsp_extensions.nvim {}
      :onsails/lspkind-nvim {:mod :lspkind}
      :RishabhRD/popfix {}
      :RishabhRD/nvim-lsputils {}
      :kosayoda/nvim-lightbulb {}

      ;; Appearance

      :norcalli/nvim-colorizer.lua {:mod :colorizer}
      :Firef0x/PKGBUILD.vim {}
      :ekalinin/Dockerfile.vim {}

      ;; Formatters
      :sbdchd/neoformat {:mod :neoformat}

      ;; Git plugins
      :sindrets/diffview.nvim {}
      :TimUntersberger/neogit {:requires :nvim-lua/plenary.nvim :mod :neogit}
      :lewis6991/gitsigns.nvim {:requires :nvim-lua/plenary.nvim :branch :main :mod :gitsigns}
      :tpope/vim-fugitive {}
      :christoomey/vim-conflicted {}
      :ruifm/gitlinker.nvim {:requires :nvim-lua/plenary.nvim :mod :gitlinker}

      ;; HTML and CSS Plugins
      :hail2u/vim-css3-syntax {}
      :othree/html5.vim {}
      :mattn/emmet-vim {}
      :windwp/nvim-ts-autotag {}

      ;; Javascript Plugins
      :pangloss/vim-javascript {}
      :maxmellon/vim-jsx-pretty {}
      :jose-elias-alvarez/nvim-lsp-ts-utils {}
      :mvolkmann/vim-react {}
      :benjie/local-npm-bin.vim {}
      :Quramy/vim-js-pretty-template {:mod :pretty-template}
      :vuki656/package-info.nvim {:mod :package-info}
      :MunifTanjim/nui.nvim {}
      :JoosepAlviste/nvim-ts-context-commentstring {}

      ;; Typescript
      :leafgarland/typescript-vim {}
      :peitalin/vim-jsx-typescript {}

      ;; Java/Android/Gradle plugins
      :georgewfraser/java-language-server {:run "./scripts/link_mac.sh"}

      ;; Kotlin
      :donniewest/kotlin-vim {}
      :fwcd/kotlin-language-server {:run "./gradlew :server:installDist" :branch "main"}

      ;; Writing Plugins
      :rhysd/vim-grammarous {:mod :grammarous}
      :jxnblk/vim-mdx-js {}
      :gabrielelana/vim-markdown {}
      :vhyrro/neorg {:requires :nvim-lua/plenary.nvim :mod :neorg}

      ;; SQL
      :tpope/vim-dadbod {}
      :kristijanhusak/vim-dadbod-completion {}
      :kristijanhusak/vim-dadbod-ui {}

      ;; Clojure
      :guns/vim-sexp {:mod :sexp}
      :tpope/vim-sexp-mappings-for-regular-people {}

      :Olical/conjure {:mod :conjure}
      :dmac/vim-cljfmt {}

      :clojure-vim/clojure.vim {}
      :gpanders/nvim-parinfer {}


      ;; Fennel
      :Olical/aniseed {}
      :Olical/fennel.vim {}
      :elkowar/antifennel-nvim {}
      :elkowar/nvim-gehzu {:mod :gehzu}})
