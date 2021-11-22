(module plugin.package-info
        {require {core aniseed.core
                  nvim aniseed.nvim
                  package package-info
                  au zest.au
                  z zest.lib}
         require-macros [zest.macros]})


(package.setup)

(au- [BufWritePost] :package.json #(package.show))
