(module plugin.compe
  {require {nvim aniseed.nvim
            :conjure-compe plugin.conjure
            nu aniseed.nvim.util}})

(let [compe (require :compe)]
      (compe.register_source :conjure conjure-compe.source)
      (compe.setup
        {:enabled true
         :autocomplete true
         :debug false
         :min_length 1
         :preselect "enabled"
         :throttle_time 80
         :source_timeout 200
         :incomplete_delay 400
         :max_abbr_width 100
         :max_kind_width 100
         :max_menu_width 100
         :documentation true
         :source
         {:conjure true
           :path true
           :buffer false
           :calc false
           :vsnip false
           :nvim_lsp true
           :nvim_lua true
           :spell false
           :tags false
           :snippets_nvim true
           :treesitter false
           :vim_dadbod_completion true}}))

(nvim.ex.set "completeopt=menuone,noselect")
(nvim.set_keymap :i :<C-x><C-o> "compe#complete()" {:expr true :silent true })
(nvim.set_keymap :i :<C-e> "compe#close('<C-e>')" {:expr true :silent true })
