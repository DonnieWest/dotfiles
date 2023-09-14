(module plugin {require {nvim aniseed.nvim
                         a aniseed.core
                         util util
                         packer packer}})

(defn- safe-require-plugin-config [name]
       "Safely require a module under the plugin.* prefix. Will catch errors
  and print them while continuing execution, allowing other plugins to load
  even if one configuration module is broken."
       (let [(ok? val-or-err) (pcall require (.. :.plugin. name))]
         (when (not ok?)
           (print (.. "Plugin config error: " val-or-err)))))

(defn req [name] "A shortcut to building a require string for your plugin
  configuration. Intended for use with packer's config or setup
  configuration options. Will prefix the name with `magic.plugin.`
  before requiring." (.. "require('magic.plugin." name "')"))

(defn use [pkgs] "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well.
  This is just a helper / syntax sugar function to make interacting with packer
  a little more concise."
      (packer.startup (fn [use]
                        (each [name opts (pairs pkgs)]
                          (-?> (. opts :mod) (safe-require-plugin-config))
                          (use (a.assoc opts 1 name))))) nil)

;; Plugins to be managed by packer.

;; fnlfmt: skip
(use {:wbthomason/packer.nvim {} ;; Manage Packer w/ Packer
      ;; Generic Plugins
      :tpope/vim-repeat {}
      :tpope/vim-surround {}
      :tpope/vim-tbone {}
      :duggiefresh/vim-easydir {}
      :tpope/vim-eunuch {}
      :RRethy/nvim-treesitter-endwise {}
      :tpope/vim-abolish {}
      :jiangmiao/auto-pairs {:mod :auto-pairs}
      :junegunn/vim-easy-align {:mod :easy-align}
      :ggandor/leap.nvim {:mod :leap}

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
      :lewis6991/impatient.nvim {:compile_path (.. (vim.fn.stdpath :config) "/lua/packer_compiled.lua")}

      ;; UI
      :blueyed/vim-diminactive {}

      :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"}
      :nvim-treesitter/playground {}
      :nvim-treesitter/nvim-treesitter-textobjects {}
      :HiPhish/nvim-ts-rainbow2 {}
      :nvim-treesitter/nvim-treesitter-refactor {}
      :mhinz/vim-startify {:mod :startify}

      :itchyny/lightline.vim {:mod :lightline}
      :mgee/lightline-bufferline {}
      :josa42/nvim-lightline-lsp {}

      :ryanoasis/vim-devicons {}
      :yamatsum/nvim-web-nonicons {}
      :kyazdani42/nvim-web-devicons {}
      :folke/todo-comments.nvim {:mod :todo-comments}
      :DonnieWest/nvim-base16.lua {}
      :folke/lsp-colors.nvim {}
      :mrshmllow/document-color.nvim {}
      :glts/vim-textobj-comment {:requires :kana/vim-textobj-user}
      :stevearc/dressing.nvim {:mod :dressing}

      ;; Themes
      :barrientosvctor/abyss.nvim {}
      :EdenEast/nightfox.nvim {}
      :rose-pine/neovim {}

      ;; Generic IDE features

      :rhysd/clever-f.vim {}
      :tomtom/tcomment_vim {:mod :tcomment}

      :nvim-telescope/telescope.nvim {:mod :telescope}
      :nvim-telescope/telescope-fzf-native.nvim {:run :make}
      :nvim-telescope/telescope-frecency.nvim {:requires :tami5/sqlite.lua}

      :ibhagwan/fzf-lua {}

      :chipsenkbeil/distant.nvim {:mod :distant}
      :folke/trouble.nvim {:mod :trouble}
      :j-hui/fidget.nvim {:mod :fidget :branch :legacy}
      :pwntester/octo.nvim {:mod :octo
                            :requires [:nvim-telescope/telescope.nvim
                                       :kyazdani42/nvim-web-devicons
                                       :nvim-lua/plenary.nvim]}

      :mbbill/undotree {:mod :undotree}
      :DonnieWest/vim-dirvish {:mod :dirvish}

      :mfussenegger/nvim-dap {:mod :dap}
      :rcarriga/nvim-dap-ui {}
      :theHamsta/nvim-dap-virtual-text {}
      :nvim-telescope/telescope-dap.nvim {}

      :kassio/neoterm {}

      :nvim-lua/popup.nvim {}
      :nvim-lua/plenary.nvim {}
      :junegunn/fzf.vim {:mod :fzf}
      :junegunn/fzf {}

      :mhinz/vim-grepper {:mod :grepper}
      :mfussenegger/nvim-lint {:mod :lint}
      :lpoto/actions.nvim {:mod :actions}


      :gpanders/editorconfig.nvim {}
      :justinmk/vim-gtfo {}
      :liuchengxu/vista.vim {:mod :vista}
      :noahfrederick/vim-skeleton {:mod :skeleton}
      :ThePrimeagen/refactoring.nvim {:mod :refactoring}

      :zbirenbaum/neodim {:mod :neodim :branch :v2}

      ;; Completion

      :hrsh7th/nvim-cmp {:mod :cmp}
      :PaterJason/cmp-conjure {}
      :hrsh7th/cmp-nvim-lsp {}
      :hrsh7th/cmp-nvim-lsp-signature-help {}
      :hrsh7th/cmp-nvim-lua {}
      :hrsh7th/cmp-path {}

      :jubnzv/virtual-types.nvim {}

      :L3MON4D3/LuaSnip {:mod :luasnip}
      :saadparwaiz1/cmp_luasnip {}

      :petertriho/cmp-git {:requires :nvim-lua/plenary.nvim}
      :rafamadriz/friendly-snippets {}

      :ray-x/lsp_signature.nvim {:mod :signature}
      :jose-elias-alvarez/null-ls.nvim {:mod :null}

      ;; LSP Features

      :neovim/nvim-lspconfig {:mod :lsp}
      :nvim-lua/lsp_extensions.nvim {}
      :onsails/lspkind-nvim {:mod :lspkind}
      :RishabhRD/popfix {}
      :RishabhRD/nvim-lsputils {}
      :kosayoda/nvim-lightbulb {}
      :b0o/schemastore.nvim {}
      :onsails/diaglist.nvim {:mod :diaglist}

      ;; Appearance

      :RRethy/vim-hexokinase {:run "make hexokinase"}
      :Firef0x/PKGBUILD.vim {}
      :ekalinin/Dockerfile.vim {}

      ;; Formatters
      :mhartington/formatter.nvim {:mod :formatter}

      ;; Git plugins
      :sindrets/diffview.nvim {}
      :NeogitOrg/neogit {:requires :nvim-lua/plenary.nvim :mod :neogit}
      :lewis6991/gitsigns.nvim {:requires :nvim-lua/plenary.nvim :branch :main :mod :gitsigns}
      :tpope/vim-fugitive {}
      :tpope/vim-rhubarb {}
      :ruifm/gitlinker.nvim {:requires :nvim-lua/plenary.nvim :mod :gitlinker}
      :akinsho/git-conflict.nvim {:mod :conflict}

      ;; HTML and CSS Plugins
      :hail2u/vim-css3-syntax {}
      :othree/html5.vim {}
      :mattn/emmet-vim {}
      :windwp/nvim-ts-autotag {}

      ;; Javascript Plugins
      :pangloss/vim-javascript {}
      :maxmellon/vim-jsx-pretty {}
      :mvolkmann/vim-react {}
      :benjie/local-npm-bin.vim {}
      :Quramy/vim-js-pretty-template {:mod :pretty-template}
      :vuki656/package-info.nvim {:mod :package-info}
      :MunifTanjim/nui.nvim {}
      :JoosepAlviste/nvim-ts-context-commentstring {}
      :David-Kunz/cmp-npm {}
      :barrett-ruth/import-cost.nvim {:run "sh install.sh npm" :mod :cost}

      ;; Typescript
      :leafgarland/typescript-vim {}
      :peitalin/vim-jsx-typescript {}
      :jose-elias-alvarez/typescript.nvim {}

      ;; Java/Android/Gradle plugins
      :hsanson/vim-android {:mod :android}
      :mfussenegger/nvim-jdtls {}

      ;; Kotlin
      :fwcd/kotlin-language-server {:run "./gradlew :server:installDist" :branch "main"}
      :microsoft/vscode-gradle {:run "./gradlew installDist" :branch "main"}

      ;; Writing Plugins
      :rhysd/vim-grammarous {:mod :grammarous}
      :jxnblk/vim-mdx-js {}
      :gabrielelana/vim-markdown {}
      :preservim/vim-wordy {}
      :preservim/vim-lexical {:mod :lexical}
      :mickael-menu/zk-nvim {:mod :zk}

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
      :gpanders/nvim-parinfer {:mod :parinfer}

      ;; GraphQL
      :jparise/vim-graphql {}


      ;; Fennel
      :Olical/aniseed {}
      :Olical/fennel.vim {}
      :elkowar/antifennel-nvim {}
      :elkowar/nvim-gehzu {:mod :gehzu}})

