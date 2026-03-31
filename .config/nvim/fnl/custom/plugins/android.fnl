{1 :hsanson/vim-android
 :init (fn []
         (set vim.g.gradle_sync_on_load 0)
         (set vim.g.gradle_set_classpath 0))
 :config (fn []
           (local api vim.api)
           (local augroup (api.nvim_create_augroup :AndroidLiveReload {:clear true}))
           (local timer-var {:timer nil})

           (fn debounce-apply []
             (when timer-var.timer
               (timer-var.timer:stop))
             (set timer-var.timer (vim.uv.new_timer))
             (timer-var.timer:start 500 0
                                     (vim.schedule_wrap
                                       (fn []
                                         (vim.notify "Applying changes..." :info {:title :AndroidLiveReload})
                                         (vim.fn.jobstart "adc reload apply"
                                                          {:on_stdout (fn [_ data]
                                                                       (let [output (table.concat data "\n")]
                                                                         (when (and output (not (= output "")))
                                                                           (print output))))
                                                           :on_stderr (fn [_ data]
                                                                       (let [output (table.concat data "\n")]
                                                                         (when (and output (not (= output "")))
                                                                           (when (not (output:match "live reload session"))
                                                                             (vim.notify output :warn {:title :AndroidLiveReload})))))
                                                           :on_exit (fn [_ code]
                                                                     (if (= code 0)
                                                                         (vim.notify "Changes applied!" :info {:title :AndroidLiveReload})
                                                                         (vim.notify "Build failed - check output" :warn {:title :AndroidLiveReload})))})
                                         (when timer-var.timer
                                           (timer-var.timer:stop)
                                           (set timer-var.timer nil))))))

           (api.nvim_create_autocmd :BufWritePost
                                    {:group augroup
                                     :pattern ["*.kt" "*.kts"]
                                     :callback (fn []
                                                 (when (or (vim.fn.filereadable "./gradlew")
                                                           (vim.fn.filereadable "../gradlew")
                                                           (vim.fn.filereadable "./build.gradle")
                                                           (vim.fn.filereadable "./build.gradle.kts"))
                                                   (debounce-apply)))})

           (api.nvim_create_autocmd :BufWritePost
                                    {:group augroup
                                     :pattern ["*.xml"]
                                     :callback (fn []
                                                 (let [filepath (vim.fn.expand "%:p")]
                                                   (when (and (or (filepath:match "res/layout")
                                                                  (filepath:match "res/values"))
                                                              (or (vim.fn.filereadable "./gradlew")
                                                                  (vim.fn.filereadable "../gradlew")))
                                                     (debounce-apply))))})

           (api.nvim_create_autocmd :BufWritePost
                                    {:group augroup
                                     :pattern ["build.gradle" "build.gradle.kts" "settings.gradle" "settings.gradle.kts"]
                                     :callback (fn []
                                                 (vim.notify "Gradle file changed - sync may be required" :warn {:title :AndroidLiveReload}))})

           (vim.keymap.set :n :<leader>alr
                           (fn []
                             (vim.notify "Initializing live reload..." :info {:title :AndroidLiveReload})
                             (vim.fn.jobstart "adc reload init"
                                              {:on_stdout (fn [_ data]
                                                           (let [output (table.concat data "\n")]
                                                             (when (and output (not (= output "")))
                                                               (print output))))
                                               :on_stderr (fn [_ data]
                                                           (let [output (table.concat data "\n")]
                                                             (when (and output (not (= output "")))
                                                               (vim.notify output :error {:title :AndroidLiveReload}))))
                                               :on_exit (fn [_ code]
                                                         (if (= code 0)
                                                             (vim.notify "Live reload initialized!" :info {:title :AndroidLiveReload})
                                                             (vim.notify "Failed to initialize" :error {:title :AndroidLiveReload})))}))
                           {:desc "Initialize Android Live Reload"})

           (vim.keymap.set :n :<leader>ala
                           (fn []
                             (vim.notify "Applying changes..." :info {:title :AndroidLiveReload})
                             (vim.fn.jobstart "adc reload apply"
                                              {:on_stdout (fn [_ data]
                                                           (let [output (table.concat data "\n")]
                                                             (when (and output (not (= output "")))
                                                               (print output))))
                                               :on_exit (fn [_ code]
                                                         (if (= code 0)
                                                             (vim.notify "Changes applied!" :info {:title :AndroidLiveReload})
                                                             (vim.notify "Build failed" :error {:title :AndroidLiveReload})))}))
                           {:desc "Apply Android Changes (manual)"})

           (vim.keymap.set :n :<leader>als
                           (fn []
                             (vim.fn.jobstart "adc reload status"
                                              {:on_stdout (fn [_ data]
                                                           (let [output (table.concat data "\n")]
                                                             (when (and output (not (= output "")))
                                                               (print output))))}))
                           {:desc "Show Live Reload Status"})

           (vim.keymap.set :n :<leader>alc
                           (fn []
                             (vim.fn.jobstart "adc reload clear"
                                              {:on_exit (fn []
                                                         (vim.notify "Live reload session cleared" :info {:title :AndroidLiveReload}))}))
                           {:desc "Clear Live Reload Session"})

           (local live-reload-enabled {:value true})
           (vim.keymap.set :n :<leader>alt
                           (fn []
                             (set live-reload-enabled.value (not live-reload-enabled.value))
                             (if live-reload-enabled.value
                                 (do
                                   (api.nvim_clear_autocmds {:group augroup})
                                   (vim.notify "Live reload enabled" :info {:title :AndroidLiveReload}))
                                 (do
                                   (api.nvim_clear_autocmds {:group augroup})
                                   (vim.notify "Live reload disabled" :info {:title :AndroidLiveReload}))))
                           {:desc "Toggle Android Live Reload"}))}
