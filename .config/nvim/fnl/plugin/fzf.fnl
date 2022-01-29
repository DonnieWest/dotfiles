(module plugin.fzf {require {nvim aniseed.nvim mapping mapping}})

(mapping.noremap :n :<C-p> ":Files<CR>")

(vim.schedule (fn []
                (nvim.ex.autocmd :FileType :fzf "tnoremap <buffer> <esc> <c-c>")))

