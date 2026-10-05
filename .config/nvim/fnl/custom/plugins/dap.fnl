{1 :mfussenegger/nvim-dap
 :keys [:<F5>
        :<F10>
        :<F11>
        :<F12>
        :<leader>dc
        :<leader>dv
        :<leader>di
        :<leader>do
        :<leader>db
        :<leader>dB
        :<leader>dr
        :<leader>dl
        :<leader>dt]
 :dependencies [{1 :igorlfs/nvim-dap-view :opts {:auto_toggle true}}
                :nvim-telescope/telescope-dap.nvim
                {1 :mxsdev/nvim-dap-vscode-js
                 :dependencies [{1 :microsoft/vscode-js-debug
                                 :build "curl -L https://github.com/microsoft/vscode-js-debug/releases/download/v1.117.0/js-debug-dap-v1.117.0.tar.gz -o js-debug-dap.tar.gz && rm -rf out && tar -xzf js-debug-dap.tar.gz && mv js-debug out && rm js-debug-dap.tar.gz"}]}]
 :config (fn []
           (let [dap (require :dap)
                 dap-view (require :dap-view)
                 dap-vscode-js (require :dap-vscode-js)
                 nearest-file (fn [name]
                                (let [start (vim.fs.dirname (vim.api.nvim_buf_get_name 0))
                                      matches (vim.fs.find name
                                                           {:path start
                                                            :upward true
                                                            :type :file})]
                                  (. matches 1)))
                 nearest-root (fn [markers]
                                (or (vim.fs.root (vim.api.nvim_buf_get_name 0)
                                                 markers)
                                    (vim.fn.getcwd)))]
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
                    :skipFiles [:<node_internals>/** :node_modules/**]}
                   {:type :pwa-node
                    :request :attach
                    :name "Attach to Node process"
                    :processId (fn []
                                 ((. (require :dap.utils) :pick_process)))
                    :cwd "${workspaceFolder}"
                    :sourceMaps true
                    :skipFiles [:<node_internals>/** :node_modules/**]}
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
                    :runtimeArgs (fn []
                                   [:--inspect-brk
                                    (assert (nearest-file :node_modules/vitest/vitest.mjs)
                                            "Could not find vitest/vitest.mjs")
                                    :run
                                    "${file}"
                                    :--no-file-parallelism])
                    :cwd (fn []
                           (nearest-root [:vitest.config.ts
                                          :vitest.config.js
                                          :vite.config.ts
                                          :vite.config.js]))
                    :console :integratedTerminal
                    :sourceMaps true
                    :skipFiles [:<node_internals>/** :node_modules/**]}])
             ;; TypeScript/React use same configs
             (set dap.configurations.typescript dap.configurations.javascript)
             (set dap.configurations.typescriptreact
                  dap.configurations.javascript)
             (set dap.configurations.javascriptreact
                  dap.configurations.javascript)
             ;; Java/Android debugging via the jls debug adapter (attach only)
             (let [sysname (. (vim.uv.os_uname) :sysname)
                   adapter (.. (vim.fn.stdpath :data) :/lazy/jls/dist/
                               (if (= sysname :Darwin)
                                   :debug_adapter_mac.sh
                                   :debug_adapter_linux.sh))
                   gradle-root (fn []
                                 (nearest-root [:settings.gradle
                                                :settings.gradle.kts
                                                :pom.xml
                                                :.git]))
                   source-roots (fn []
                                  (let [root (gradle-root)]
                                    (vim.fn.glob (.. root
                                                     "/**/src/*/{java,kotlin}")
                                                 false true)))
                   ask-port (fn []
                              (let [port (vim.fn.input "Port: " :5005)]
                                (or (tonumber port) 5005)))
                   guess-app-id (fn []
                                  (let [root (gradle-root)
                                        files (vim.fn.glob (.. root
                                                               "/*/build.gradle{,.kts}")
                                                           false true)]
                                    (var found nil)
                                    (each [_ file (ipairs files) &until found]
                                      (each [_ line (ipairs (vim.fn.readfile file))
                                             &until found]
                                        (set found
                                             (line:match "applicationId%s*=?%s*[\"']([%w%._]+)[\"']"))))
                                    (or found "")))
                   adb (fn [args]
                         (let [out (vim.fn.system (vim.list_extend [:adb] args))]
                           (when (not= vim.v.shell_error 0)
                             (error (.. "adb " (table.concat args " ")
                                        " failed: " out)))
                           (vim.trim out)))
                   android-port (fn []
                                  (assert (= (vim.fn.executable :adb) 1)
                                          "adb not found; install the Android SDK platform-tools")
                                  (let [app-id (vim.fn.input "Application id: "
                                                             (guess-app-id))
                                        pid (adb [:shell :pidof :-s app-id])
                                        port 5005]
                                    (assert (not= pid "")
                                            (.. app-id
                                                " is not running (is it a debuggable build?)"))
                                    (adb [:forward
                                          (.. "tcp:" port)
                                          (.. "jdwp:" pid)])
                                    port))]
               (set dap.adapters.java {:type :executable :command adapter})
               (set dap.configurations.java
                    [{:type :java
                      :request :attach
                      :name "Attach to JVM (port)"
                      :port ask-port
                      :sourceRoots source-roots}
                     {:type :java
                      :request :attach
                      :name "Attach to Android app (adb jdwp)"
                      :port android-port
                      :sourceRoots source-roots}])
               (set dap.configurations.kotlin dap.configurations.java))
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
             (vim.keymap.set :n :<leader>dt dap-view.toggle
                             {:desc "DAP: Toggle UI"})))}
