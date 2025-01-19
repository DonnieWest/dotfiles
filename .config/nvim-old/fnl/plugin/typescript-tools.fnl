(module plugin.typescript-tools
        {require {nvim aniseed.nvim
                  mapping mapping
                  typescript-tools typescript-tools}})

(typescript-tools.setup {:expose_as_code_action :all :code_lens :all})

