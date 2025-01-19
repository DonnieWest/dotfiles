(module plugin.fzf {require {nvim aniseed.nvim mapping mapping}})

(vim.schedule (fn []
                (nvim.ex.autocmd :FileType :fzf "tnoremap <buffer> <esc> <c-c>")))

