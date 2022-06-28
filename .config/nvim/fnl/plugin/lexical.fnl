(module plugin.lexical {require {nvim aniseed.nvim}})

(nvim.ex.autocmd :FileType :markdown "call lexical#init()")
