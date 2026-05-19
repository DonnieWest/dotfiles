{1 :NickvanDyke/opencode.nvim
 :dependencies [:folke/snacks.nvim]
 :config (fn []
           ;; Configuration options
           (set vim.g.opencode_opts {})
           ;; Required for opts.events.reload
           (set vim.o.autoread true)
           ;; Helper local for cleaner code
           (local oc (require :opencode))
           (let [normalize-url (fn [target]
                                 (let [target (vim.trim target)]
                                   (if (= target "")
                                       nil
                                       (target:match "^%d+$")
                                       (.. "http://localhost:" target)
                                       (target:match "^https?://")
                                       target
                                       (.. "http://" target))))
                 connect (fn [target]
                           (let [url (normalize-url target)]
                             (if (not url)
                                 (vim.notify "Usage: OpencodeConnect <port-or-url>"
                                             vim.log.levels.ERROR
                                             {:title :opencode})
                                 (let [server-mod (require :opencode.server)
                                       promise (server-mod.new url)
                                       connected-promise (promise:next (fn [server] (server:connect)))
                                       notified-promise (connected-promise:next
                                                         (fn [server]
                                                           (vim.notify (.. "Connected to opencode at "
                                                                           (server:display_name))
                                                                       vim.log.levels.INFO
                                                                       {:title :opencode})))]
                                   (notified-promise:catch
                                    (fn [err]
                                      (vim.notify (or err (.. "Failed to connect to opencode at " url))
                                                  vim.log.levels.ERROR
                                                  {:title :opencode})))))))]
             (vim.api.nvim_create_user_command :OpencodeConnect
                                               (fn [opts] (connect opts.args))
                                               {:nargs 1}))
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
