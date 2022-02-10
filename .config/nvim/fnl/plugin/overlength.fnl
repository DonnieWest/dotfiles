(module plugin.overlength {require {nvim aniseed.nvim}})

(vim.fn.overlength#set_overlength :kotlin 100)
(vim.fn.overlength#disable_filetypes [:markdown :startify :qf :NeogitStatus :NeogitCommitMessage])
(set nvim.g.overlength#highlight_to_end_of_line false)
(set nvim.g.overlength#default_overlength 80)

