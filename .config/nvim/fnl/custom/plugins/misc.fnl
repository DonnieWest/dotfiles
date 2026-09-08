[;; Generic Plugins
 {1 :tpope/vim-repeat :event :VeryLazy}
 {1 :kylechui/nvim-surround :event :VeryLazy :opts {}}
 {1 :tpope/vim-eunuch :event :VeryLazy}
 {1 :tpope/vim-abolish :event :VeryLazy}
 {1 :kaymmm/bullets.nvim :ft [:markdown :text] :opts {}}
 ;; VIM Quirks fixes
 :lervag/file-line ;; Must load early for file:line opening to work
 {1 :eugen0329/vim-esearch
  :keys [{1 :<leader>ff 2 "<cmd>call esearch#init()<cr>"}]}
 {1 :Valloric/ListToggle :cmd [:LToggle :QToggle]}
 {1 :pgdouyon/vim-evanesco :event :VeryLazy}
 {1 :chentoast/marks.nvim :event :BufReadPost :opts {}}
 ;; UI
 {1 :catgoose/nvim-colorizer.lua
  :event :BufReadPre
  :opts {:user_default_options {:suppress_deprecation true}}}
 {1 :blueyed/vim-diminactive :event :WinEnter}
 ;; Generic IDE features
 {1 :rhysd/clever-f.vim :keys [:f :F :t :T]}
 {1 :nvim-lua/popup.nvim :lazy true} ;; Dependency, loaded when needed
 {1 :rafamadriz/friendly-snippets :event :InsertEnter}
 {1 :RRethy/vim-illuminate :event :BufReadPost}
 {1 :stevearc/quicker.nvim :ft :qf :opts {}}
 {1 :stevearc/overseer.nvim
  :cmd [:OverseerOpen
        :OverseerClose
        :OverseerToggle
        :OverseerRun
        :OverseerShell
        :OverseerTaskAction]
  :opts {:dap true
         :task_list {:direction :bottom}}
  :keys [{1 :<leader>or 2 :<cmd>OverseerRun<cr> :desc "Overseer: Run task"}
         {1 :<leader>ot 2 :<cmd>OverseerToggle<cr> :desc "Overseer: Toggle tasks"}
         {1 :<leader>oa 2 :<cmd>OverseerTaskAction<cr> :desc "Overseer: Task action"}]}
 ;; Git plugins
 {1 :sindrets/diffview.nvim :cmd [:DiffviewOpen :DiffviewFileHistory]}
 {:url "https://codeberg.org/trevorhauter/gitportal.nvim"}
 {1 :esmuellert/codediff.nvim
  :dependencies [:MunifTanjim/nui.nvim]
  :cmd [:CodeDiff]}
 {1 :tpope/vim-fugitive :cmd [:Git :G :Gread :Gwrite :Gdiffsplit :Gvdiffsplit]}
 {1 :tpope/vim-rhubarb :cmd [:GBrowse] :dependencies [:tpope/vim-fugitive]}
 {1 :almo7aya/openingh.nvim
  :cmd [:OpenInGHRepo :OpenInGHFile :OpenInGHFileLines]}
 ;; HTML and CSS Plugins
 {1 :mattn/emmet-vim
  :ft [:html
       :css
       :scss
       :javascript
       :javascriptreact
       :typescript
       :typescriptreact]}
 {1 :benjie/local-npm-bin.vim
  :ft [:javascript :typescript :javascriptreact :typescriptreact]}
 ;; SQL
 {1 :tpope/vim-dadbod :cmd [:DB]}
 {1 :kristijanhusak/vim-dadbod-ui
  :cmd [:DBUI :DBUIToggle]
  :dependencies [:tpope/vim-dadbod]}
 ;; Clojure
 {1 :dmac/vim-cljfmt :ft :clojure}
 {1 :clojure-vim/clojure.vim :ft :clojure}
 ;; Lisp
 {1 :dundalek/parpar.nvim :ft [:clojure :fennel :lisp :scheme] :opts {}}
 ;; Fennel
 {1 :Olical/fennel.vim :ft :fennel}
 {1 :tris203/precognition.nvim
  :version :v1.2.0
  :opts {:startVisible true :disabled_fts [:startify]}}
 {1 :fwcd/kotlin-language-server
  :ft :kotlin
  :build "./gradlew :server:installDist"}
 {1 :microsoft/vscode-gradle
  :ft [:kotlin :java :gradle :groovy]
  :build "for home in $(/usr/libexec/java_home -v 21 2>/dev/null) $(/usr/libexec/java_home -v 17 2>/dev/null) /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home; do [ -x \"$home/bin/java\" ] || continue; major=$(\"$home/bin/java\" -version 2>&1 | sed -n 's/.* version \"\\([0-9][0-9]*\\).*/\\1/p' | head -1); case \"$major\" in 21|17) JAVA_HOME=$home; break;; esac; done; if [ -z \"$JAVA_HOME\" ]; then echo 'vscode-gradle requires JDK 21 or 17 to build; install one with: brew install openjdk@21' >&2; exit 1; fi; export JAVA_HOME; ./gradlew :gradle-language-server:installDist"}
 {1 :idelice/jls :ft :java :build "./scripts/build.sh"}]
