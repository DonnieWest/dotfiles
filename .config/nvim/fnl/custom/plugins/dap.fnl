{1 :mfussenegger/nvim-dap
 :dependencies [{1 :rcarriga/nvim-dap-ui :opts {}}
                :nvim-neotest/nvim-nio
                {1 :theHamsta/nvim-dap-virtual-text :opts {}}
                :igorlfs/nvim-dap-view
                :nvim-telescope/telescope-dap.nvim
                {1 :mfussenegger/nvim-dap-python :ft :python}]
 :config (fn []
           (let [dap (require :dap)
                 dapui (require :dapui)]
             ;; Auto-open/close UI
             (tset dap.listeners.before.event_terminated :dapui_config
                   (fn [] (dapui.close)))
             (tset dap.listeners.before.event_exited :dapui_config
                   (fn [] (dapui.close)))
             (tset dap.listeners.after.event_initialized :dapui_config
                   (fn [] (dapui.open)))
             ;; Node.js debugger adapter - uses pwa-node (built-in inspector protocol)
             (set dap.adapters.pwa-node
                  {:type :server
                   :host :localhost
                   :port "${port}"
                   :executable {:command :node
                                :args [(vim.fn.expand "~/.local/share/nvim/dap-adapters/js-debug/src/dapDebugServer.js")
                                       "${port}"]}})
             ;; Chrome/React Native debugger (requires: npm install -g debugger-for-chrome)
             (set dap.adapters.chrome
                  {:type :executable
                   :command :node
                   :args [(vim.fn.expand "~/.local/share/nvim/dap-adapters/vscode-chrome-debug/out/src/chromeDebug.js")]})
             ;; Configurations for JavaScript/TypeScript/React Native
             (set dap.configurations.javascript
                  [{:type :chrome
                    :request :attach
                    :name "Attach to Chrome (React Native)"
                    :port 9222
                    :sourceMaps true
                    :webRoot (vim.fn.getcwd)
                    :sourceMapPathOverrides {"webpack:///./*" "${webRoot}/*"
                                             "webpack:///src/*" "${webRoot}/*"
                                             "webpack:///*" "*"
                                             "webpack:///./~/*" "${webRoot}/node_modules/*"}}])
             ;; TypeScript/React use same configs
             (set dap.configurations.typescript dap.configurations.javascript)
             (set dap.configurations.typescriptreact
                  dap.configurations.javascript)
             (set dap.configurations.javascriptreact
                  dap.configurations.javascript)
             ;; Python debugging (requires: pip install debugpy)
             (let [dap-python (require :dap-python)]
               ;; Use debugpy from current python environment
               (dap-python.setup (or (vim.fn.exepath :python3) :python3))
               ;; Python configurations
               (set dap.configurations.python
                    [{:type :python
                      :request :launch
                      :name "Launch file"
                      :program "${file}"
                      :pythonPath (fn []
                                    (or (vim.fn.exepath :python)
                                        (vim.fn.exepath :python3) :python3))}
                     {:type :python
                      :request :launch
                      :name "Launch with arguments"
                      :program "${file}"
                      :args (fn []
                              (let [args (vim.fn.input "Arguments: ")]
                                (vim.split args " +")))
                      :pythonPath (fn []
                                    (or (vim.fn.exepath :python)
                                        (vim.fn.exepath :python3) :python3))}
                     {:type :python
                      :request :launch
                      :name "Pytest: Current File"
                      :module :pytest
                      :args ["${file}" :-v]
                      :console :integratedTerminal
                      :pythonPath (fn []
                                    (or (vim.fn.exepath :python)
                                        (vim.fn.exepath :python3) :python3))}
                     {:type :python
                      :request :launch
                      :name "Pytest: All Tests"
                      :module :pytest
                      :args [:-v]
                      :console :integratedTerminal
                      :pythonPath (fn []
                                    (or (vim.fn.exepath :python)
                                        (vim.fn.exepath :python3) :python3))}
                     {:type :python
                      :request :attach
                      :name "Attach to Remote"
                      :connect {:host :localhost :port 5678}
                      :pathMappings [{:localRoot (vim.fn.getcwd)
                                      :remoteRoot "."}]}]))
             ;; Java debugging (requires: JDTLS running with java-debug plugin)
             ;; The adapter will be configured by nvim-java/JDTLS
             ;; Java configurations for Maven and Gradle projects
             (set dap.configurations.java
                  [{:type :java
                    :request :launch
                    :name "Launch Current File"
                    :mainClass "${file}"}
                   {:type :java
                    :request :launch
                    :name "Launch with Arguments"
                    :mainClass (fn []
                                 (vim.fn.input "Main class: "))
                    :args (fn []
                            (let [args (vim.fn.input "Arguments: ")]
                              (if (= args "")
                                  []
                                  (vim.split args " +"))))}
                   {:type :java
                    :request :attach
                    :name "Attach to Remote JVM"
                    :hostName :localhost
                    :port (fn []
                            (or (vim.fn.input "Port: ") :5005))}
                   {:type :java
                    :request :launch
                    :name "Maven Test (Current File)"
                    :mainClass ""
                    :projectName (fn []
                                   (vim.fn.fnamemodify (vim.fn.getcwd) ":t"))
                    :cwd (vim.fn.getcwd)
                    :console :integratedTerminal
                    :args [:-Dtest= "${fileBasenameNoExtension}"]}
                   {:type :java
                    :request :launch
                    :name "Gradle Test (Current File)"
                    :mainClass ""
                    :projectName (fn []
                                   (vim.fn.fnamemodify (vim.fn.getcwd) ":t"))
                    :cwd (vim.fn.getcwd)
                    :console :integratedTerminal
                    :args [:--tests "${fileBasenameNoExtension}"]}
                   {:type :java
                    :request :launch
                    :name "Android App (Debug)"
                    :mainClass ""
                    :projectName (fn []
                                   (vim.fn.fnamemodify (vim.fn.getcwd) ":t"))
                    :cwd (vim.fn.getcwd)
                    :console :integratedTerminal
                    :android true}])
             ;; Keybindings
             ;; F-keys for debugging
             (vim.keymap.set :n :<F5> dap.continue {:desc "DAP: Continue"})
             (vim.keymap.set :n :<F10> dap.step_over {:desc "DAP: Step Over"})
             (vim.keymap.set :n :<F11> dap.step_into {:desc "DAP: Step Into"})
             (vim.keymap.set :n :<F12> dap.step_out {:desc "DAP: Step Out"})
             ;; Leader-prefixed alternatives
             (vim.keymap.set :n :<leader>dc dap.continue
                             {:desc "DAP: Continue"})
             (vim.keymap.set :n :<leader>dv dap.step_over
                             {:desc "DAP: Step Over"})
             (vim.keymap.set :n :<leader>di dap.step_into
                             {:desc "DAP: Step Into"})
             (vim.keymap.set :n :<leader>do dap.step_out
                             {:desc "DAP: Step Out"})
             ;; Breakpoints
             (vim.keymap.set :n :<leader>db dap.toggle_breakpoint
                             {:desc "DAP: Toggle Breakpoint"})
             (vim.keymap.set :n :<leader>dB
                             (fn []
                               (dap.set_breakpoint (vim.fn.input "Breakpoint condition: ")))
                             {:desc "DAP: Conditional Breakpoint"})
             ;; Other DAP commands
             (vim.keymap.set :n :<leader>dr dap.repl.open
                             {:desc "DAP: Open REPL"})
             (vim.keymap.set :n :<leader>dl dap.run_last
                             {:desc "DAP: Run Last"})
             (vim.keymap.set :n :<leader>dt dapui.toggle
                             {:desc "DAP: Toggle UI"})))}
