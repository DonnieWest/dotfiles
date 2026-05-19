{1 :mfussenegger/nvim-dap
  :dependencies [{1 :rcarriga/nvim-dap-ui :opts {}}
                 :nvim-neotest/nvim-nio
                 {1 :theHamsta/nvim-dap-virtual-text :opts {}}
                 :igorlfs/nvim-dap-view
                 :nvim-telescope/telescope-dap.nvim
                  {1 :mxsdev/nvim-dap-vscode-js
                   :dependencies [{1 :microsoft/vscode-js-debug
                                   :build "curl -L https://github.com/microsoft/vscode-js-debug/releases/download/v1.117.0/js-debug-dap-v1.117.0.tar.gz -o js-debug-dap.tar.gz && rm -rf out && tar -xzf js-debug-dap.tar.gz && mv js-debug out && rm js-debug-dap.tar.gz"}]}]
  :config (fn []
            (let [dap (require :dap)
                  dapui (require :dapui)
                  dap-vscode-js (require :dap-vscode-js)]
             ;; Auto-open/close UI
             (tset dap.listeners.before.event_terminated :dapui_config
                   (fn [] (dapui.close)))
             (tset dap.listeners.before.event_exited :dapui_config
                   (fn [] (dapui.close)))
             (tset dap.listeners.after.event_initialized :dapui_config
                   (fn [] (dapui.open)))
              (dap-vscode-js.setup {:debugger_path (.. (vim.fn.stdpath :data)
                                                       :/lazy/vscode-js-debug)
                                    :debugger_cmd [:node
                                                   (.. (vim.fn.stdpath :data)
                                                       :/lazy/vscode-js-debug/out/src/dapDebugServer.js)]
                                    :adapters [:pwa-node
                                               :pwa-chrome
                                               :node-terminal
                                               :pwa-extensionHost]})
              ;; Configurations for JavaScript/TypeScript/Vite
              (set dap.configurations.javascript
                   [{:type :pwa-node
                     :request :launch
                     :name "Launch current file"
                     :program "${file}"
                     :cwd "${workspaceFolder}"
                     :console :integratedTerminal
                     :sourceMaps true
                     :skipFiles ["<node_internals>/**" "node_modules/**"]}
                    {:type :pwa-node
                     :request :attach
                     :name "Attach to Node process"
                     :processId (fn [] ((. (require :dap.utils) :pick_process)))
                     :cwd "${workspaceFolder}"
                     :sourceMaps true
                     :skipFiles ["<node_internals>/**" "node_modules/**"]}
                    {:type :pwa-chrome
                     :request :attach
                     :name "Attach to Chrome (Vite)"
                     :port 9222
                     :url "http://localhost:5173"
                     :webRoot "${workspaceFolder}"
                     :sourceMaps true}
                    {:type :pwa-node
                     :request :launch
                     :name "Debug Vitest current file"
                     :runtimeExecutable :node
                     :runtimeArgs [:--inspect-brk
                                   "${workspaceFolder}/node_modules/vitest/vitest.mjs"
                                   :run
                                   "${file}"
                                   :--no-file-parallelism]
                     :cwd "${workspaceFolder}"
                     :console :integratedTerminal
                     :sourceMaps true
                     :skipFiles ["<node_internals>/**" "node_modules/**"]}])
             ;; TypeScript/React use same configs
             (set dap.configurations.typescript dap.configurations.javascript)
             (set dap.configurations.typescriptreact
                  dap.configurations.javascript)
             (set dap.configurations.javascriptreact
                  dap.configurations.javascript)
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
