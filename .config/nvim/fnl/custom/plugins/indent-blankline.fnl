{1 :lukas-reineke/indent-blankline.nvim
 :main :ibl
 :event :BufReadPost
 :opts {:indent {:char "│"
                 :tab_char "│"}
        :scope {:enabled true
                :show_start true
                :show_end false}
        :exclude {:filetypes [:help
                              :dashboard
                              :neo-tree
                              :Trouble
                              :lazy
                              :mason
                              :notify
                              :toggleterm
                              :lazyterm]}}}
