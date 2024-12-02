(module plugin.formatter
        {require {nvim aniseed.nvim
                  mapping mapping
                  formatter formatter
                  defaults formatter.defaults
                  util formatter.util}})

(mapping.noremap :n :<leader>fm ":Format<CR>")

(formatter.setup {:filetype {:fennel [(fn []
                                        {:exe :fnlfmt :args ["-"] :stdin true})]
                             :javascript (util.copyf defaults.prettier)
                             :kotlin [(fn []
                                        {:exe :ktfmt :args ["-"] :stdin true})]}})

