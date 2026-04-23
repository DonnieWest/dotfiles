(local M {})
(local kotlin-tools (require :custom.kotlin-tools))

(local state {:auto-apply false :group nil})

(fn project-root []
  (let [buf-path (vim.api.nvim_buf_get_name 0)]
    (when (not= buf-path "")
      (vim.fs.root buf-path [:.git
                             :gradlew
                             :build.gradle
                             :build.gradle.kts
                             :settings.gradle
                             :settings.gradle.kts]))))

(fn jetstart-project? [root]
  (and root (vim.uv.fs_stat (.. root "/jetstart.config.json"))))

(fn notify-lines [data level title]
  (let [lines []]
    (each [_ line (ipairs (or data []))]
      (when (and line (not= line ""))
        (table.insert lines line)))
    (when (> (length lines) 0)
      (vim.notify (table.concat lines "\n") level {:title title}))))

(fn run-adc [args ?opts]
  (let [opts (or ?opts {})
        root (project-root)]
    (if (not root)
        (vim.notify "Not in an Android project" vim.log.levels.WARN {:title :AndroidReload})
        (do
          (when (jetstart-project? root)
            (vim.notify "JetStart project detected; prefer 'jetstart dev' for active hot reload"
                        vim.log.levels.WARN
                        {:title :AndroidReload}))
          (let [job-opts {:cwd root
                          :stdout_buffered true
                          :stderr_buffered true
                          :on_stdout (or opts.on_stdout
                                          (fn [_ data]
                                            (notify-lines data vim.log.levels.INFO :AndroidReload)))
                          :on_stderr (or opts.on_stderr
                                          (fn [_ data]
                                            (notify-lines data vim.log.levels.ERROR :AndroidReload)))
                          :on_exit (or opts.on_exit
                                       (fn [_ code]
                                         (when (not= code 0)
                                           (vim.notify (.. "Command failed with exit code " code)
                                                       vim.log.levels.ERROR
                                                       {:title :AndroidReload}))))}]
            (vim.fn.jobstart args job-opts))))))

(fn clear-auto-apply []
  (when state.group
    (vim.api.nvim_clear_autocmds {:group state.group})))

(fn register-auto-apply []
  (set state.group (or state.group
                       (vim.api.nvim_create_augroup :AndroidReload {:clear true})))
  (clear-auto-apply)
  (vim.api.nvim_create_autocmd :BufWritePost
                               {:group state.group
                                :pattern [:*.kt :*.kts :*.xml]
                                :callback (fn []
                                            (when (and state.auto-apply (project-root))
                                              (run-adc [:adc :reload :apply]
                                                       {:on_exit (fn [_ code]
                                                                   (if (= code 0)
                                                                       (vim.notify "Android changes applied"
                                                                                   vim.log.levels.INFO
                                                                                   {:title :AndroidReload})
                                                                       (vim.notify "Android apply failed"
                                                                                   vim.log.levels.ERROR
                                                                                   {:title :AndroidReload})))})))}))

(fn reload-init []
  (vim.notify "Initializing Android reload session" vim.log.levels.INFO {:title :AndroidReload})
  (run-adc [:adc :reload :init]
           {:on_exit (fn [_ code]
                       (if (= code 0)
                           (vim.notify "Android reload initialized" vim.log.levels.INFO {:title :AndroidReload})
                           (vim.notify "Failed to initialize Android reload" vim.log.levels.ERROR {:title :AndroidReload}))) }))

(fn reload-apply []
  (vim.notify "Applying Android changes" vim.log.levels.INFO {:title :AndroidReload})
  (run-adc [:adc :reload :apply]
           {:on_exit (fn [_ code]
                       (if (= code 0)
                           (vim.notify "Android changes applied" vim.log.levels.INFO {:title :AndroidReload})
                           (vim.notify "Android apply failed" vim.log.levels.ERROR {:title :AndroidReload}))) }))

(fn reload-status []
  (run-adc [:adc :reload :status]))

(fn reload-clear []
  (run-adc [:adc :reload :clear]
           {:on_exit (fn [_ code]
                       (if (= code 0)
                           (vim.notify "Android reload session cleared" vim.log.levels.INFO {:title :AndroidReload})
                           (vim.notify "Failed to clear Android reload session" vim.log.levels.ERROR {:title :AndroidReload}))) }))

(fn toggle-auto-apply []
  (set state.auto-apply (not state.auto-apply))
  (if state.auto-apply
      (do
        (register-auto-apply)
        (vim.notify "Android auto-apply enabled on save" vim.log.levels.WARN {:title :AndroidReload}))
      (do
        (clear-auto-apply)
        (vim.notify "Android auto-apply disabled" vim.log.levels.INFO {:title :AndroidReload}))))

(fn M.setup []
  (let [package-group (vim.api.nvim_create_augroup :KotlinPackageInsert {:clear true})]
    (vim.api.nvim_create_autocmd :BufNewFile
                                 {:group package-group
                                  :pattern :*.kt
                                  :callback (fn [args]
                                              (pcall kotlin-tools.maybe-insert-package args.buf))})
    (pcall kotlin-tools.maybe-insert-package (vim.api.nvim_get_current_buf)))
  (vim.api.nvim_create_user_command :AndroidReloadInit reload-init {:desc "Initialize adc reload session"})
  (vim.api.nvim_create_user_command :AndroidReloadApply reload-apply {:desc "Apply Android changes with adc"})
  (vim.api.nvim_create_user_command :AndroidReloadStatus reload-status {:desc "Show adc reload status"})
  (vim.api.nvim_create_user_command :AndroidReloadClear reload-clear {:desc "Clear adc reload session"})
  (vim.api.nvim_create_user_command :AndroidReloadToggleAuto toggle-auto-apply {:desc "Toggle Android auto-apply on save"})
  (vim.keymap.set :n :<leader>alr reload-init {:desc "Initialize Android reload"})
  (vim.keymap.set :n :<leader>ala reload-apply {:desc "Apply Android changes"})
  (vim.keymap.set :n :<leader>als reload-status {:desc "Show Android reload status"})
  (vim.keymap.set :n :<leader>alc reload-clear {:desc "Clear Android reload session"})
  (vim.keymap.set :n :<leader>alt toggle-auto-apply {:desc "Toggle Android auto-apply"}))

M
