local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin.fnl"
local _2amodule_name_2a = "plugin"
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
local a, nvim, packer, util = require("aniseed.core"), require("aniseed.nvim"), require("packer"), require("util")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["packer"] = packer
_2amodule_locals_2a["util"] = util
local function safe_require_plugin_config(name)
  local ok_3f, val_or_err = pcall(require, (".plugin." .. name))
  if not ok_3f then
    return print(("Plugin config error: " .. val_or_err))
  else
    return nil
  end
end
_2amodule_locals_2a["safe-require-plugin-config"] = safe_require_plugin_config
local function req(name)
  return ("require('magic.plugin." .. name .. "')")
end
_2amodule_2a["req"] = req
local function use(pkgs)
  local function _2_(use0)
    for name, opts in pairs(pkgs) do
      do
        local _3_ = opts.mod
        if (nil ~= _3_) then
          safe_require_plugin_config(_3_)
        else
        end
      end
      use0(a.assoc(opts, 1, name))
    end
    return nil
  end
  packer.startup(_2_)
  return nil
end
_2amodule_2a["use"] = use
use({["wbthomason/packer.nvim"] = {}, ["tpope/vim-repeat"] = {}, ["tpope/vim-surround"] = {}, ["tpope/vim-tbone"] = {}, ["duggiefresh/vim-easydir"] = {}, ["tpope/vim-eunuch"] = {}, ["RRethy/nvim-treesitter-endwise"] = {}, ["tpope/vim-abolish"] = {}, ["windwp/nvim-autopairs"] = {mod = "auto-pairs"}, ["AndrewRadev/splitjoin.vim"] = {}, ["junegunn/vim-easy-align"] = {mod = "easy-align"}, ["ggandor/leap.nvim"] = {mod = "leap"}, ["dkarter/bullets.vim"] = {}, ["lervag/file-line"] = {}, ["pbrisbin/vim-mkdir"] = {}, ["mhinz/vim-sayonara"] = {command = "Sayonara", mod = "sayonara"}, ["romainl/vim-qf"] = {mod = "qf"}, ["eugen0329/vim-esearch"] = {}, ["airblade/vim-rooter"] = {}, ["christoomey/vim-tmux-navigator"] = {mod = "navigator"}, ["Valloric/ListToggle"] = {}, ["Yggdroot/indentLine"] = {mod = "indentLine"}, ["pgdouyon/vim-evanesco"] = {}, ["kshenoy/vim-signature"] = {}, ["lewis6991/impatient.nvim"] = {compile_path = (vim.fn.stdpath("config") .. "/lua/packer_compiled.lua")}, ["blueyed/vim-diminactive"] = {}, ["nvim-treesitter/nvim-treesitter"] = {run = ":TSUpdate"}, ["nvim-treesitter/playground"] = {}, ["nvim-treesitter/nvim-treesitter-textobjects"] = {}, ["nvim-treesitter/nvim-treesitter-refactor"] = {}, ["mhinz/vim-startify"] = {mod = "startify"}, ["itchyny/lightline.vim"] = {mod = "lightline"}, ["mgee/lightline-bufferline"] = {}, ["josa42/nvim-lightline-lsp"] = {}, ["ryanoasis/vim-devicons"] = {}, ["yamatsum/nvim-web-nonicons"] = {}, ["kyazdani42/nvim-web-devicons"] = {}, ["folke/todo-comments.nvim"] = {mod = "todo-comments"}, ["DonnieWest/nvim-base16.lua"] = {}, ["RRethy/nvim-base16"] = {}, ["folke/lsp-colors.nvim"] = {}, ["Wansmer/symbol-usage.nvim"] = {mod = "symbol-usage"}, ["mrshmllow/document-color.nvim"] = {}, ["glts/vim-textobj-comment"] = {requires = "kana/vim-textobj-user"}, ["stevearc/dressing.nvim"] = {mod = "dressing"}, ["barrientosvctor/abyss.nvim"] = {}, ["EdenEast/nightfox.nvim"] = {}, ["mhartington/oceanic-next"] = {}, ["rose-pine/neovim"] = {}, ["rhysd/clever-f.vim"] = {}, ["tomtom/tcomment_vim"] = {mod = "tcomment"}, ["fabridamicelli/cronex.nvim"] = {mod = "cronex"}, ["nvim-telescope/telescope.nvim"] = {mod = "telescope"}, ["nvim-telescope/telescope-fzf-native.nvim"] = {run = "make"}, ["nvim-telescope/telescope-frecency.nvim"] = {requires = "tami5/sqlite.lua"}, ["ibhagwan/fzf-lua"] = {}, ["folke/trouble.nvim"] = {mod = "trouble"}, ["j-hui/fidget.nvim"] = {mod = "fidget", branch = "legacy"}, ["pwntester/octo.nvim"] = {mod = "octo", requires = {"nvim-telescope/telescope.nvim", "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim"}}, ["tzachar/cmp-ai"] = {mod = "cmp-ai"}, ["mbbill/undotree"] = {mod = "undotree"}, ["DonnieWest/vim-dirvish"] = {mod = "dirvish"}, ["mfussenegger/nvim-dap"] = {mod = "dap"}, ["rcarriga/nvim-dap-ui"] = {requires = "nvim-neotest/nvim-nio"}, ["theHamsta/nvim-dap-virtual-text"] = {}, ["nvim-telescope/telescope-dap.nvim"] = {}, ["kassio/neoterm"] = {}, ["nvim-lua/popup.nvim"] = {}, ["nvim-lua/plenary.nvim"] = {}, ["junegunn/fzf.vim"] = {mod = "fzf"}, ["junegunn/fzf"] = {}, ["mhinz/vim-grepper"] = {mod = "grepper"}, ["mfussenegger/nvim-lint"] = {mod = "lint"}, ["gpanders/editorconfig.nvim"] = {}, ["justinmk/vim-gtfo"] = {}, ["liuchengxu/vista.vim"] = {mod = "vista"}, ["noahfrederick/vim-skeleton"] = {mod = "skeleton"}, ["ThePrimeagen/refactoring.nvim"] = {mod = "refactoring"}, ["zbirenbaum/neodim"] = {mod = "neodim"}, ["hrsh7th/nvim-cmp"] = {mod = "cmp"}, ["PaterJason/cmp-conjure"] = {}, ["hrsh7th/cmp-nvim-lsp"] = {}, ["hrsh7th/cmp-nvim-lsp-signature-help"] = {}, ["hrsh7th/cmp-nvim-lua"] = {}, ["hrsh7th/cmp-path"] = {}, ["monkoose/neocodeium"] = {mod = "neocodeium"}, ["yetone/avante.nvim"] = {mod = "avante", run = "make", requires = {"MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "stevearc/dressing.nvim"}}, ["MeanderingProgrammer/render-markdown.nvim"] = {}, ["jubnzv/virtual-types.nvim"] = {}, ["L3MON4D3/LuaSnip"] = {mod = "luasnip"}, ["saadparwaiz1/cmp_luasnip"] = {}, ["petertriho/cmp-git"] = {requires = "nvim-lua/plenary.nvim"}, ["rafamadriz/friendly-snippets"] = {}, ["ray-x/lsp_signature.nvim"] = {mod = "signature"}, ["neovim/nvim-lspconfig"] = {mod = "lsp"}, ["nvim-lua/lsp_extensions.nvim"] = {}, ["onsails/lspkind-nvim"] = {mod = "lspkind"}, ["RishabhRD/popfix"] = {}, ["RishabhRD/nvim-lsputils"] = {}, ["b0o/schemastore.nvim"] = {}, ["onsails/diaglist.nvim"] = {mod = "diaglist"}, ["RRethy/vim-hexokinase"] = {run = "make hexokinase"}, ["Firef0x/PKGBUILD.vim"] = {}, ["ekalinin/Dockerfile.vim"] = {}, ["mhartington/formatter.nvim"] = {mod = "formatter"}, ["sindrets/diffview.nvim"] = {}, ["NeogitOrg/neogit"] = {requires = "nvim-lua/plenary.nvim", mod = "neogit"}, ["lewis6991/gitsigns.nvim"] = {requires = "nvim-lua/plenary.nvim", branch = "main", mod = "gitsigns"}, ["tpope/vim-fugitive"] = {}, ["tpope/vim-rhubarb"] = {}, ["ruifm/gitlinker.nvim"] = {requires = "nvim-lua/plenary.nvim", mod = "gitlinker"}, ["akinsho/git-conflict.nvim"] = {mod = "conflict"}, ["hail2u/vim-css3-syntax"] = {}, ["othree/html5.vim"] = {}, ["mattn/emmet-vim"] = {}, ["windwp/nvim-ts-autotag"] = {}, ["pangloss/vim-javascript"] = {}, ["maxmellon/vim-jsx-pretty"] = {}, ["mvolkmann/vim-react"] = {}, ["benjie/local-npm-bin.vim"] = {}, ["Quramy/vim-js-pretty-template"] = {mod = "pretty-template"}, ["vuki656/package-info.nvim"] = {mod = "package-info"}, ["MunifTanjim/nui.nvim"] = {}, ["JoosepAlviste/nvim-ts-context-commentstring"] = {}, ["David-Kunz/cmp-npm"] = {}, ["barrett-ruth/import-cost.nvim"] = {run = "sh install.sh npm", mod = "cost"}, ["leafgarland/typescript-vim"] = {}, ["peitalin/vim-jsx-typescript"] = {}, ["pmizio/typescript-tools.nvim"] = {mod = "typescript-tools"}, ["hsanson/vim-android"] = {mod = "android"}, ["mfussenegger/nvim-jdtls"] = {}, ["fwcd/kotlin-language-server"] = {run = "./gradlew :server:installDist", branch = "main"}, ["microsoft/vscode-gradle"] = {run = "./gradlew installDist", branch = "main"}, ["rhysd/vim-grammarous"] = {mod = "grammarous"}, ["jxnblk/vim-mdx-js"] = {}, ["gabrielelana/vim-markdown"] = {}, ["preservim/vim-wordy"] = {}, ["preservim/vim-lexical"] = {mod = "lexical"}, ["mickael-menu/zk-nvim"] = {mod = "zk"}, ["tpope/vim-dadbod"] = {}, ["kristijanhusak/vim-dadbod-completion"] = {}, ["kristijanhusak/vim-dadbod-ui"] = {}, ["Olical/conjure"] = {mod = "conjure"}, ["dmac/vim-cljfmt"] = {}, ["clojure-vim/clojure.vim"] = {}, ["gpanders/nvim-parinfer"] = {mod = "parinfer"}, ["julienvincent/nvim-paredit"] = {mod = "paredit"}, ["dundalek/parpar.nvim"] = {}, ["jparise/vim-graphql"] = {}, ["Olical/aniseed"] = {}, ["Olical/fennel.vim"] = {}, ["elkowar/antifennel-nvim"] = {}, ["elkowar/nvim-gehzu"] = {mod = "gehzu"}})
return _2amodule_2a