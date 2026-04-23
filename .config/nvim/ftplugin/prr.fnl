(set vim.opt_local.foldmethod :expr)
(set vim.opt_local.foldexpr "v:lua.require('custom.prr-fold').fold_level()")
(set vim.opt_local.foldcolumn :3)
(set vim.b.undo_ftplugin "setl fdm< | setl fde< | setl fdc<")
