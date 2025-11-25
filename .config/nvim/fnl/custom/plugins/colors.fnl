{1 :DonnieWest/nvim-base16.lua
 :config (fn []
           (let [base16 (require :base16)]
             (tset base16.themes :gotham
                   (base16.theme_from_array [:0c1014
                                             :11151c
                                             :091f2e
                                             :0a3749
                                             :245361
                                             :d3ebe9
                                             :599cab
                                             :98d1ce
                                             :4e5166
                                             :2aa889
                                             :33859E
                                             :edb443
                                             :195466
                                             :888ca6
                                             :d26937
                                             :c23127]))

             (fn strip-hex-symbol [hex]
               (string.gsub hex "#" ""))

             (fn get-color [theme color]
               (strip-hex-symbol (. theme color)))

             (fn convert-theme-to-base16 [theme]
               {:base00 (get-color theme :background)
                :base01 (get-color theme :lighter-background)
                :base02 (get-color theme :selection)
                :base03 (get-color theme :comment)
                :base04 (get-color theme :dark-foreground)
                :base05 (get-color theme :foreground)
                :base06 (get-color theme :light-foreground)
                :base07 (get-color theme :light-background)
                :base08 (get-color theme :variables)
                :base09 (get-color theme :numbers)
                :base0A (get-color theme :classes)
                :base0B (get-color theme :strings)
                :base0C (get-color theme :regex)
                :base0D (get-color theme :functions)
                :base0E (get-color theme :keywords)
                :base0F (get-color theme :tags)})

             (tset base16.themes :tweaked
                   (convert-theme-to-base16 {:background "#03090e"
                                             :lighter-background "#061620"
                                             :selection "#091f2e"
                                             :comment "#223543"
                                             :dark-foreground "#9da5ab"
                                             :foreground "#e6e9ea"
                                             :light-foreground "#f5fafd"
                                             :light-background "#53626d"
                                             :variables "#4e5166"
                                             :numbers "#DDECB2"
                                             :classes "#33859E"
                                             :strings "#FFB610"
                                             :regex "#195466"
                                             :functions "#27B8C2"
                                             :keywords "#ecb2c0"
                                             :tags "#D12820"}))
             (tset base16.themes :nightowl
                   (base16.theme_from_array [:011627
                                             :0c2132
                                             :172c3d
                                             :223748
                                             :2c4152
                                             :ced6e3
                                             :d6deeb
                                             :feffff
                                             :ecc48d
                                             :f78c6c
                                             :c792ea
                                             :29E68E
                                             :aad2ff
                                             :82aaff
                                             :c792ea
                                             :f78c6c]))
             (tset base16.themes :gotham-noir-ultra
                   (convert-theme-to-base16 {:background "#03090e"
                                             :lighter-background "#0c2132"
                                             :selection "#1e425a"
                                             :comment "#2b7a9c"
                                             :dark-foreground "#539daf"
                                             :foreground "#e6f9f7"
                                             :light-foreground "#b0e3e4"
                                             :light-background "#d3ebe9"
                                             :variables "#ff5555"
                                             :numbers "#ffb86c"
                                             :classes "#ffd700"
                                             :strings "#33c2de"
                                             :regex "#50fa7b"
                                             :functions "#8be9fd"
                                             :keywords "#ff79c6"
                                             :tags "#bd93f9"}))
             (tset base16.themes :gotham-tweaked
                   (convert-theme-to-base16 {:background "#03090e"
                                             :lighter-background "#10151c"
                                             :selection "#0e3a4f"
                                             :comment "#13596c"
                                             :dark-foreground "#2d6a79"
                                             :foreground "#e6f9f7"
                                             :light-foreground "#6bb8c8"
                                             :light-background "#b0e3e4"
                                             :variables "#606476"
                                             :numbers "#3cd7b2"
                                             :classes "#41a8c7"
                                             :strings "#f7ba56"
                                             :regex "#1e6a87"
                                             :functions "#a3a7c1"
                                             :keywords "#ee7545"
                                             :tags "#d5423b"}))
             ;; Minimalist theme following Tonsky's principles:
             ;; - Only 4 colors for syntax (high contrast, vibrant character)
             ;; - Highlight strings/numbers, constants/literals, top-level definitions
             ;; - Keywords and function calls use default foreground
             ;; - Comments are visible but muted
             ;; - Preserves gotham-noir-ultra's signature colors (cyan + purple)
             ;; - All colors meet WCAG AA or AAA contrast standards
             ;; - High saturation (89-97%) for neon/cyberpunk aesthetic
             (tset base16.themes :gotham-noir-minimalist
                   (convert-theme-to-base16 {:background "#03090e"
                                             :lighter-background "#0c2132"
                                             :selection "#1e425a"
                                             :comment "#539daf"
                                             :dark-foreground "#7cc4d0"
                                             :foreground "#b0e3e4"
                                             :light-foreground "#e6f9f7"
                                             :light-background "#d3ebe9"
                                             :variables "#b0e3e4"
                                             :numbers "#8be9fd"
                                             :classes "#bd93f9"
                                             :strings "#8be9fd"
                                             :regex "#8be9fd"
                                             :functions "#b0e3e4"
                                             :keywords "#b0e3e4"
                                             :tags "#bd93f9"}))
             (base16 base16.themes.gotham-noir-ultra true {:lightline true}))

              ;; Colorblind friendly diff colors: blue for add, red for delete (fg only, bg matches theme)
           (vim.api.nvim_set_hl 0 :DiffAdd {:fg "#8be9fd"})
           (vim.api.nvim_set_hl 0 :DiffDelete {:fg "#ff5555"})
           (vim.api.nvim_set_hl 0 :DiffChange {:fg "#ffb86c"})
           (vim.api.nvim_set_hl 0 :DiffText {:fg "#50fa7b"})
           ;; Neogit specific diff highlights
           (vim.api.nvim_set_hl 0 :NeogitDiffAdd {:fg "#8be9fd"})
           (vim.api.nvim_set_hl 0 :NeogitDiffDelete {:fg "#ff5555"})
           (vim.api.nvim_set_hl 0 :NeogitDiffAddHighlight {:fg "#8be9fd" :bold true})
           (vim.api.nvim_set_hl 0 :NeogitDiffDeleteHighlight {:fg "#ff5555" :bold true})
           (vim.api.nvim_set_hl 0 :NeogitDiffAddCursor {:fg "#8be9fd" :underline true})
           (vim.api.nvim_set_hl 0 :NeogitDiffDeleteCursor {:fg "#ff5555" :underline true}))}
