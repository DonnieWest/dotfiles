(module plugin.neogit {require {nvim aniseed.nvim neogit neogit}})

(neogit.setup {:disable_context_highlighting true
               :integrations {:diffview true}})

(nvim.ex.autocmd :BufWritePost :* "lua require(\"neogit\").refresh_viml_compat()")
