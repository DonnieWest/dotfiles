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
             ;; gotham-noir-ultra with targeted fixes:
             ;; - comments raised to visible teal (#5fafc7)
             ;; - variables dropped to foreground (red=error is misleading)
             ;; - classes swapped to purple (gold/orange were too similar)
             ;; - tags folded into orange (constants/literals)
             (tset base16.themes :gotham-noir-ultra-v2
                   (convert-theme-to-base16 {:background "#03090e"
                                             :lighter-background "#0c2132"
                                             :selection "#1e425a"
                                             :comment "#5fafc7"
                                             :dark-foreground "#539daf"
                                             :foreground "#e6f9f7"
                                             :light-foreground "#b0e3e4"
                                             :light-background "#d3ebe9"
                                             :variables "#e6f9f7"
                                             :numbers "#ffb86c"
                                             :classes "#bd93f9"
                                             :strings "#33c2de"
                                             :regex "#50fa7b"
                                             :functions "#8be9fd"
                                             :keywords "#ff79c6"
                                             :tags "#ffb86c"}))
             ;; Tonsky-inspired: 4 memorable syntax colors, everything else default foreground.
             ;; cyan=string | orange=number/literal | purple=definition | amber=comment
             ;; Keywords, variables, function calls all fall back to foreground (noise reduction).
             (tset base16.themes :gotham-noir-focused
                   (convert-theme-to-base16 {:background "#03090e"
                                             :lighter-background "#0c2132"
                                             :selection "#1e425a"
                                             :comment "#c8a96e"
                                             :dark-foreground "#539daf"
                                             :foreground "#e6f9f7"
                                             :light-foreground "#b0e3e4"
                                             :light-background "#d3ebe9"
                                             :variables "#e6f9f7"
                                             :numbers "#ffb86c"
                                             :classes "#bd93f9"
                                             :strings "#33c2de"
                                             :regex "#33c2de"
                                             :functions "#e6f9f7"
                                             :keywords "#e6f9f7"
                                             :tags "#ffb86c"}))
             ;; Evidence-guided palette: neutral routine code, cyan structure/strings,
             ;; amber literals, muted comments, and red reserved for errors.
             (tset base16.themes :gotham-noir-research
                   (convert-theme-to-base16 {:background "#03090e"
                                             :lighter-background "#0c2132"
                                             :selection "#1e425a"
                                             :comment "#4b91a3"
                                             :dark-foreground "#4b91a3"
                                             :foreground "#e6f9f7"
                                             :light-foreground "#b0e3e4"
                                             :light-background "#d3ebe9"
                                             :variables "#e6f9f7"
                                             :numbers "#edb443"
                                             :classes "#bd93f9"
                                             :strings "#33c2de"
                                             :regex "#33c2de"
                                             :functions "#8be9fd"
                                             :keywords "#d26937"
                                             :tags "#bd93f9"}))
             (base16 base16.themes.gotham-noir-research true {:lightline true}))
           (local palette {:background "#03090e"
                           :surface "#0c2132"
                           :selection "#1e425a"
                           :muted "#4b91a3"
                           :foreground "#e6f9f7"
                           :light "#b0e3e4"
                           :cool "#33c2de"
                           :cool_bright "#8be9fd"
                           :member "#2aa889"
                           :keyword "#d26937"
                           :warm "#edb443"
                           :error "#ff5555"
                           :ok "#50fa7b"
                           :purple "#bd93f9"})

           (fn set-hl [group options]
             (vim.api.nvim_set_hl 0 group options))

           (fn link-groups [groups target]
             (each [_ group (ipairs groups)]
               (set-hl group {:link target})))

           (fn apply-terminal-colors []
             ;; The Base16 plugin incorrectly uses base0E as the dark terminal
             ;; foreground. Keep ANSI meanings independent from syntax slots.
             (set vim.g.terminal_color_background palette.background)
             (set vim.g.terminal_color_foreground palette.foreground)
             (let [colors [palette.background
                           palette.error
                           palette.ok
                           palette.warm
                           palette.cool
                           palette.purple
                           palette.cool
                           palette.foreground
                           palette.muted
                           palette.error
                           palette.ok
                           palette.warm
                           palette.cool_bright
                           palette.purple
                           palette.cool_bright
                           palette.light]]
               (each [index color (ipairs colors)]
                 (tset vim.g (.. "terminal_color_" (- index 1)) color))))

           (fn apply-research-highlights []
             ;; Keep high-frequency variables and punctuation neutral while
             ;; giving grammatical, callable, type/member, and literal roles
             ;; stable colors across Tree-sitter and LSP.
             (set-hl :GothamSyntaxNeutral {:fg palette.foreground})
             (set-hl :GothamSyntaxKeyword {:fg palette.keyword :italic true})
             (set-hl :GothamSyntaxComment {:fg palette.muted :italic true})
             (set-hl :GothamSyntaxCool {:fg palette.cool})
             (set-hl :GothamSyntaxCallable {:fg palette.cool_bright})
             (set-hl :GothamSyntaxDefinition
                     {:fg palette.cool_bright :bold true})
             (set-hl :GothamSyntaxMember {:fg palette.member})
             (set-hl :GothamSyntaxType {:fg palette.purple})
             (set-hl :GothamSyntaxWarm {:fg palette.warm})
             (set-hl :GothamSyntaxError {:fg palette.error :bold true})
             (set-hl :GothamSyntaxTodo {:fg palette.warm :bold true})
             ;; Legacy syntax groups remain important for non-Tree-sitter files
             ;; and are the default targets for many modern captures.
             (link-groups [:Identifier :Operator :Delimiter]
                          :GothamSyntaxNeutral)
             (link-groups [:Keyword
                           :Conditional
                           :Repeat
                           :Statement
                           :StorageClass
                           :Include
                           :PreProc
                           :Define
                           :Exception]
                          :GothamSyntaxKeyword)
             (link-groups [:String] :GothamSyntaxCool)
             (link-groups [:Character :Number :Float :Boolean :Constant]
                          :GothamSyntaxWarm)
             (link-groups [:Type :Typedef :Structure :Tag] :GothamSyntaxType)
             (link-groups [:Function] :GothamSyntaxDefinition)
             (link-groups [:Comment] :GothamSyntaxComment)
             ;; Modern Tree-sitter captures. Explicitly map specific captures so
             ;; Neovim's built-in links cannot reintroduce Base16 slot drift.
             (link-groups ["@variable"
                           "@variable.builtin"
                           "@variable.parameter"
                           "@variable.parameter.builtin"
                           "@operator"
                           "@punctuation"
                           "@punctuation.delimiter"
                           "@punctuation.bracket"
                           "@punctuation.special"]
                          :GothamSyntaxNeutral)
             (link-groups ["@keyword"
                           "@keyword.coroutine"
                           "@keyword.function"
                           "@keyword.operator"
                           "@keyword.import"
                           "@keyword.type"
                           "@keyword.modifier"
                           "@keyword.repeat"
                           "@keyword.return"
                           "@keyword.debug"
                           "@keyword.exception"
                           "@keyword.conditional"
                           "@keyword.conditional.ternary"
                           "@keyword.directive"
                           "@keyword.directive.define"]
                          :GothamSyntaxKeyword)
             (link-groups ["@constant"
                           "@constant.builtin"
                           "@constant.macro"
                           "@character"
                           "@character.special"
                           "@boolean"
                           "@number"
                           "@number.float"
                           "@string.escape"
                           "@string.special"]
                          :GothamSyntaxWarm)
             (link-groups ["@string"
                           "@string.documentation"
                           "@string.regexp"
                           "@string.special.symbol"
                           "@string.special.path"
                           "@string.special.url"]
                          :GothamSyntaxCool)
             (link-groups ["@function.call"
                           "@function.method.call"
                           "@function.builtin"]
                          :GothamSyntaxCallable)
             (link-groups ["@function"
                           "@function.method"
                           "@function.macro"
                           "@constructor"
                           "@type.definition"]
                          :GothamSyntaxDefinition)
             (link-groups ["@variable.member" "@property" "@tag.attribute"]
                          :GothamSyntaxMember)
             (link-groups ["@module"
                           "@module.builtin"
                           "@type"
                           "@type.builtin"
                           "@attribute"
                           "@attribute.builtin"
                           "@tag"
                           "@tag.builtin"]
                          :GothamSyntaxType)
             (link-groups ["@tag.delimiter"] :GothamSyntaxNeutral)
             ;; Some language queries use definition-shaped captures for calls.
             ;; Keep their color but avoid misleading bold weight.
             (link-groups ["@function.css"
                           "@function.scss"
                           "@function.groovy"
                           "@function.method.http"]
                          :GothamSyntaxCallable)
             (link-groups ["@comment" "@comment.documentation"]
                          :GothamSyntaxComment)
             (link-groups ["@comment.error"] :GothamSyntaxError)
             (link-groups ["@comment.warning" "@comment.todo"]
                          :GothamSyntaxTodo)
             (link-groups ["@comment.note"] :GothamSyntaxCool)
             ;; Semantic tokens outrank Tree-sitter. Preserve Tree-sitter's
             ;; definition/call distinction by disabling redundant function and
             ;; method semantic foregrounds.
             (link-groups ["@lsp.type.variable" "@lsp.type.parameter"]
                          :GothamSyntaxNeutral)
             (link-groups ["@lsp.type.property"] :GothamSyntaxMember)
             (link-groups ["@lsp.type.namespace"] :GothamSyntaxType)
             (link-groups ["@lsp.type.class"
                           "@lsp.type.enum"
                           "@lsp.type.interface"
                           "@lsp.type.struct"
                           "@lsp.type.type"
                           "@lsp.type.typeParameter"]
                          :GothamSyntaxType)
             (link-groups ["@lsp.type.enumMember" "@lsp.type.macro"]
                          :GothamSyntaxWarm)
             (set-hl "@lsp.type.function" {})
             (set-hl "@lsp.type.method" {})
             (set-hl "@lsp.type.decorator" {})
             ;; Markup keeps prose readable while making its structure visible.
             (link-groups ["@markup.raw"
                           "@markup.raw.block"
                           "@markup.link"
                           "@markup.link.label"
                           "@markup.list"]
                          :GothamSyntaxCool)
             (link-groups ["@markup.heading"] :GothamSyntaxDefinition)
             (link-groups ["@markup.quote"] :GothamSyntaxComment)
             (set-hl "@markup.strong" {:bold true})
             (set-hl "@markup.italic" {:italic true})
             (set-hl "@markup.strikethrough" {:strikethrough true})
             (set-hl "@markup.link.url" {:fg palette.cool :underline true})
             (set-hl "@markup.list.checked" {:fg palette.ok})
             (set-hl "@markup.list.unchecked" {:fg palette.warm})
             (link-groups ["@markup.math"] :GothamSyntaxWarm)
             (link-groups ["@diff.plus"] :DiffAdd)
             (link-groups ["@diff.minus"] :DiffDelete)
             (link-groups ["@diff.delta"] :DiffChange)
             ;; Stable interaction-state contrast. Visual deliberately replaces
             ;; syntax foregrounds so selected comments remain readable.
             (set-hl :Normal {:fg palette.foreground :bg palette.background})
             (set-hl :CursorLine {:bg palette.surface})
             (set-hl :Visual {:fg palette.foreground :bg palette.selection})
             (set-hl :Search {:fg palette.background :bg palette.warm})
             (set-hl :IncSearch {:fg palette.background
                                 :bg palette.cool_bright
                                 :bold true})
             (set-hl :ColorColumn {:bg palette.surface})
             (set-hl :LspInlayHint {:fg palette.muted :italic true})
             (set-hl :DiagnosticError {:fg palette.error})
             (set-hl :DiagnosticWarn {:fg palette.warm})
             (set-hl :DiagnosticInfo {:fg palette.cool})
             (set-hl :DiagnosticHint {:fg palette.muted})
             (set-hl :DiagnosticOk {:fg palette.ok})
             (set-hl :SpellBad {:sp palette.error :undercurl true})
             (set-hl :SpellLocal {:sp palette.cool :undercurl true})
             (set-hl :SpellRare {:sp palette.warm :undercurl true})
             ;; Completion and diff UI use the palette without competing with
             ;; ordinary source tokens.
             (set-hl :Pmenu {:fg palette.foreground :bg palette.surface})
             (set-hl :PmenuSel {:fg palette.foreground :bg palette.selection})
             (set-hl :PmenuSbar {:bg palette.surface})
             (set-hl :PmenuThumb {:bg palette.selection})
             (set-hl :BlinkCmpMenu {:fg palette.foreground :bg palette.surface})
             (set-hl :BlinkCmpMenuSelection
                     {:fg palette.foreground :bg palette.selection})
             (set-hl :BlinkCmpScrollBarGutter {:bg palette.surface})
             (set-hl :BlinkCmpScrollBarThumb {:bg palette.selection})
             (set-hl :DiffAdd {:fg palette.cool_bright})
             (set-hl :DiffDelete {:fg palette.error})
             (set-hl :DiffChange {:fg palette.warm})
             (set-hl :DiffText {:fg palette.foreground
                                :bg palette.selection
                                :bold true})
             (set-hl :NeogitDiffAdd {:fg palette.cool_bright})
             (set-hl :NeogitDiffDelete {:fg palette.error})
             (set-hl :NeogitDiffAddHighlight
                     {:fg palette.cool_bright :bold true})
             (set-hl :NeogitDiffDeleteHighlight {:fg palette.error :bold true})
             (set-hl :NeogitDiffAddCursor
                     {:fg palette.cool_bright :underline true})
             (set-hl :NeogitDiffDeleteCursor
                     {:fg palette.error :underline true})
             (set-hl :NeogitDiffContextHighlight {:link :CursorLine})
             (set-hl :NeogitHunkHeader {:link :TabLine})
             (set-hl :NeogitHunkHeaderHighlight {:link :DiffText})
             (apply-terminal-colors))

           (set vim.g.colors_name "gotham-noir-research")
           (apply-research-highlights)
           (let [group (vim.api.nvim_create_augroup :gotham-noir-highlights
                                                    {:clear true})]
             (vim.api.nvim_create_autocmd :ColorScheme
                                          {:group group
                                           :callback (fn []
                                                       (when (= vim.g.colors_name
                                                                "gotham-noir-research")
                                                         (apply-research-highlights)))})))}
