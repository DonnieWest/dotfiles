{1 :folke/trouble.nvim
 :cmd [:Trouble]
 :opts {:focus true}
 :keys [{1 :<leader>xx 2 "<cmd>Trouble diagnostics toggle<cr>" :desc "Diagnostics"}
        {1 :<leader>xX 2 "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" :desc "Buffer Diagnostics"}
        {1 :<leader>xs 2 "<cmd>Trouble symbols toggle<cr>" :desc "Symbols"}
        {1 :<leader>xr 2 "<cmd>Trouble lsp toggle<cr>" :desc "LSP References"}
        {1 :<leader>xl 2 "<cmd>Trouble loclist toggle<cr>" :desc "Location List"}
        {1 :<leader>xq 2 "<cmd>Trouble qflist toggle<cr>" :desc "Quickfix List"}
        {1 "[q"
         2 (fn []
             (let [trouble (require :trouble)]
               (if (trouble.is_open)
                   (trouble.prev {:skip_groups true :jump true})
                   (let [(ok err) (pcall vim.cmd.cprev)]
                     (when (not ok)
                       (vim.notify err vim.log.levels.ERROR))))))
         :desc "Previous Trouble/Quickfix Item"}
        {1 "]q"
         2 (fn []
             (let [trouble (require :trouble)]
               (if (trouble.is_open)
                   (trouble.next {:skip_groups true :jump true})
                   (let [(ok err) (pcall vim.cmd.cnext)]
                     (when (not ok)
                       (vim.notify err vim.log.levels.ERROR))))))
         :desc "Next Trouble/Quickfix Item"}]}
