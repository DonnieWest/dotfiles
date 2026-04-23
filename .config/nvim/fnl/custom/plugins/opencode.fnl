{1 :NickvanDyke/opencode.nvim
 :dependencies [:folke/snacks.nvim]
 :config (fn []
           ;; Configuration options
           (set vim.g.opencode_opts {})
           ;; Required for opts.events.reload
           (set vim.o.autoread true)
           ;; Helper local for cleaner code
           (local oc (require :opencode))
           ;; Recommended/example keymaps
           (vim.keymap.set [:n :x] :<C-a>
                           (fn [] (oc.ask "@this: " {:submit true}))
                           {:desc "Ask opencode…"})
           (vim.keymap.set [:n :x] :<C-x> (fn [] (oc.select))
                           {:desc "Execute opencode action…"})
           (vim.keymap.set [:n :t] :<C-.> (fn [] (oc.toggle))
                           {:desc "Toggle opencode"})
           ;; Operator mappings (expr = true)
           (vim.keymap.set [:n :x] :go (fn [] (oc.operator "@this "))
                           {:desc "Add range to opencode" :expr true})
           (vim.keymap.set :n :goo (fn [] (.. (oc.operator "@this ") "_"))
                           {:desc "Add line to opencode" :expr true})
           ;; Scrolling
           (vim.keymap.set :n :<S-C-u>
                           (fn [] (oc.command :session.half.page.up))
                           {:desc "Scroll opencode up"})
           (vim.keymap.set :n :<S-C-d>
                           (fn [] (oc.command :session.half.page.down))
                           {:desc "Scroll opencode down"})
           ;; Re-mapping default increment/decrement
           (vim.keymap.set :n "+" :<C-a>
                           {:desc "Increment under cursor" :noremap true})
           (vim.keymap.set :n "_" :<C-x>
                           {:desc "Decrement under cursor" :noremap true}))}
