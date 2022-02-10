(module plugin.formatter
        {require {nvim aniseed.nvim mapping mapping formatter formatter}})

(mapping.noremap :n :<leader>fm ":Format<CR>")

(formatter.setup {:filetype {:fennel [(fn []
                                        {:exe :fnlfmt :args ["-"] :stdin true})]
                             :kotlin [(fn []
                                        {:exe :ktfmt :args ["-"] :stdin true})]}})

