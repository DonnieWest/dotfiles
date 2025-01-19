local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/cmp.fnl"
local _2amodule_name_2a = "plugin.cmp"
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
local cmp, cmp_autopairs, git, lsp, lspconfig, lspkind, luasnip, npm, nvim = require("cmp"), require("nvim-autopairs.completion.cmp"), require("cmp_git"), require("cmp_nvim_lsp"), require("lspconfig"), require("lspkind"), require("luasnip"), require("cmp-npm"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["cmp"] = cmp
_2amodule_locals_2a["cmp-autopairs"] = cmp_autopairs
_2amodule_locals_2a["git"] = git
_2amodule_locals_2a["lsp"] = lsp
_2amodule_locals_2a["lspconfig"] = lspconfig
_2amodule_locals_2a["lspkind"] = lspkind
_2amodule_locals_2a["luasnip"] = luasnip
_2amodule_locals_2a["npm"] = npm
_2amodule_locals_2a["nvim"] = nvim
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return ((col ~= 0) and (((vim.api.nvim_buf_get_lines(0, (line - 1), line, true))[1]):sub(col, col):match("%s") == nil))
end
local function feedkey(key, mode)
  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local function _1_(fallback)
  if cmp.visible() then
    return cmp.select_next_item()
  elseif luasnip.expand_or_locally_jumpable() then
    return luasnip.expand_or_jump()
  elseif has_words_before() then
    return cmp.complete()
  else
    return fallback()
  end
end
local function _3_(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(( - 1)) then
    luasnip.jump(( - 1))
  else
    fallback()
  end
  return {"i", "s"}
end
local function _5_(args)
  return luasnip.lsp_expand(args.body)
end
cmp.setup({mapping = cmp.mapping.preset.insert({["<CR>"] = cmp.mapping.confirm({select = true}), ["<Tab>"] = cmp.mapping(_1_, {"i", "s"}), ["<S-Tab>"] = cmp.mapping(_3_), ["<C-e>"] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}), ["<C-x><C-o>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"})}), formatting = {format = lspkind.cmp_format({maxwidth = 80})}, snippet = {expand = _5_}, experimental = {ghost_text = true}, sources = {{name = "conjure"}, {name = "nvim_lsp"}, {name = "nvim_lsp_signature_help"}, {name = "npm", keyword_length = 4}, {name = "nvim_lua"}, {name = "path"}, {name = "git"}, {name = "vim-dadbod-completion"}}})
nvim.ex.set("completeopt=menuone,noselect")
git.setup()
npm.setup()
do end (cmp.event):on("confirm_done", cmp_autopairs.on_confirm_done())
return _2amodule_2a