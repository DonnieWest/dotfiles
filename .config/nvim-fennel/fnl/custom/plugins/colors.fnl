{1 :RRethy/base16-nvim
 :init (fn []
         (let [base16 (require :base16-colorscheme)]
           (base16.setup {:base00 "#03090e"
                          :base01 "#091f2e"
                          :base02 "#0a3749"
                          :base03 "#245361"
                          :base04 "#4e5166"
                          :base05 "#d3ebe9"
                          :base06 "#98d1ce"
                          :base07 "#d3ebe9"
                          :base08 "#2aa889"
                          :base09 "#33859e"
                          :base0A "#edb443"
                          :base0B "#195466"
                          :base0C "#599cab"
                          :base0D "#888ca6"
                          :base0E "#d26937"
                          :base0F "#c23127"})))}

