local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/telescope.fnl"
local _2amodule_name_2a = "plugin.telescope"
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
local actions, builtin, mapping, nvim, telescope = require("telescope.actions"), require("telescope.builtin"), require("mapping"), require("aniseed.nvim"), require("telescope")
do end (_2amodule_locals_2a)["actions"] = actions
_2amodule_locals_2a["builtin"] = builtin
_2amodule_locals_2a["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["telescope"] = telescope
telescope.setup({defaults = {vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "--follow", "-g", "!.git/"}, mappings = {i = {["<esc>"] = actions.close}}}, extensions = {frecency = {workspaces = {config = "$HOME/.config"}}, fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case"}}})
for _, value in ipairs({"fzf", "frecency", "refactoring", "dap"}) do
  telescope.load_extension(value)
end
local function telescopeFindFiles()
  if (vim.fn.getcwd() == vim.fn.expand("$HOME")) then
    return telescope.extensions.frecency.frecency()
  else
    return builtin.find_files()
  end
end
_2amodule_2a["telescopeFindFiles"] = telescopeFindFiles
mapping.noremap("n", "<C-p>", ":lua require('plugin.telescope').telescopeFindFiles()<CR>")
mapping.noremap("n", "\\", ":Telescope live_grep<CR>")
mapping.noremap("v", "<Leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>")
return _2amodule_2a