(local M {})

(fn notify-lines [data level title]
  (let [lines []]
    (each [_ line (ipairs (or data []))]
      (when (and line (not= line ""))
        (table.insert lines line)))
    (when (> (length lines) 0)
      (vim.notify (table.concat lines "\n") level {:title title}))))

(fn project-root []
  (let [buf-path (vim.api.nvim_buf_get_name 0)]
    (when (not= buf-path "")
      (vim.fs.root buf-path [:.git
                             :gradlew
                             :build.gradle
                             :build.gradle.kts
                             :settings.gradle
                             :settings.gradle.kts]))))

(fn require-project-root []
  (or (project-root) (error "Not in an Android project")))

(fn current-preview-name []
  (let [cursor-line (. (vim.api.nvim_win_get_cursor 0) 1)
        lines (vim.api.nvim_buf_get_lines 0 0 -1 false)]
    (var preview-start nil)
    (var preview-name nil)
    (for [idx 1 cursor-line]
      (let [line (. lines idx)]
        (when (and line (line:match "@Preview"))
          (set preview-start idx))))
    (when preview-start
      (for [idx preview-start (length lines)]
        (let [line (. lines idx)
              preview-fn (and line (line:match "fun%s+([A-Za-z_][A-Za-z0-9_]*)"))]
          (when (and preview-fn (not preview-name))
            (set preview-name preview-fn)))))
    preview-name))

(fn run-job [cmd root ?success-msg]
  (vim.fn.jobstart cmd
                  {:cwd root
                   :stdout_buffered true
                   :stderr_buffered true
                   :on_stdout (fn [_ data]
                                (notify-lines data vim.log.levels.INFO :ComposePreview))
                   :on_stderr (fn [_ data]
                                (notify-lines data vim.log.levels.ERROR :ComposePreview))
                   :on_exit (fn [_ code]
                              (if (= code 0)
                                  (when ?success-msg
                                    (vim.notify ?success-msg vim.log.levels.INFO {:title :ComposePreview}))
                                  (vim.notify (.. "compose-preview exited with code " code)
                                              vim.log.levels.ERROR
                                              {:title :ComposePreview})))}))

(fn open-tui []
  (let [root (require-project-root)]
    (vim.cmd "botright split")
    (vim.cmd (.. "terminal compose-preview " (vim.fn.shellescape root)))
    (vim.cmd "startinsert")))

(fn preview-current []
  (let [root (require-project-root)
        preview-name (current-preview-name)]
    (if preview-name
        (run-job [:compose-preview :--run preview-name root]
                 root
                 (.. "Launched preview: " preview-name))
        (vim.notify "No @Preview function found near cursor" vim.log.levels.WARN {:title :ComposePreview}))))

(fn preview-web []
  (let [root (require-project-root)]
    (run-job [:compose-preview :--web root] root "Opened compose-preview web viewer")))

(fn select-preview [items root]
  (let [labels (icollect [_ item (ipairs items)]
                 (or item.name (. item "function")))]
    (vim.ui.select labels
                   {:prompt "Compose previews:"}
                   (fn [choice idx]
                     (when (and choice idx)
                       (let [selected (. items idx)
                             preview-name (or (. selected "function") selected.name)]
                         (run-job [:compose-preview :--run preview-name root]
                                  root
                                  (.. "Launched preview: " preview-name))))))))

(fn handle-preview-list [root rel-file raw]
  (if (or (= raw "") (= raw "null"))
      (vim.notify "No compose previews found" vim.log.levels.WARN {:title :ComposePreview})
      (let [(ok decoded) (pcall vim.json.decode raw)]
        (if (not ok)
            (vim.notify "Failed to decode compose-preview JSON" vim.log.levels.ERROR {:title :ComposePreview})
            (let [items []]
              (each [_ item (ipairs decoded)]
                (when (= item.file rel-file)
                  (table.insert items item)))
              (if (= (length items) 0)
                  (vim.notify "No compose previews found for current file" vim.log.levels.WARN {:title :ComposePreview})
                  (select-preview items root)))))))

(fn preview-list []
  (let [root (require-project-root)
        abs-file (vim.api.nvim_buf_get_name 0)
        rel-file (if (vim.startswith abs-file (.. root "/"))
                     (abs-file:sub (+ (length root) 2))
                     abs-file)]
    (vim.fn.jobstart [:compose-preview :--list root]
                    {:cwd root
                     :stdout_buffered true
                     :stderr_buffered true
                     :on_stdout (fn [_ data]
                                  (handle-preview-list root rel-file (table.concat (or data []) "\n")))
                     :on_stderr (fn [_ data]
                                  (notify-lines data vim.log.levels.ERROR :ComposePreview))})))

(fn clear-cache []
  (let [root (require-project-root)]
    (run-job [:compose-preview :--clear root] root "Compose preview cache cleared")))

(fn show-status []
  (let [root (project-root)
        binary (vim.fn.exepath :compose-preview)]
    (if (= binary "")
        (vim.notify "compose-preview not found on PATH" vim.log.levels.ERROR {:title :ComposePreview})
        (let [job-opts {:stdout_buffered true
                        :on_stdout (fn [_ data]
                                     (let [version (table.concat (or data []) "\n")]
                                       (vim.notify (.. "Binary: " binary
                                                       "\nVersion: " version
                                                       "\nProject root: " (or root "Not in Android project"))
                                                   vim.log.levels.INFO
                                                   {:title :ComposePreview})))}]
          (vim.fn.jobstart [:compose-preview :--version] job-opts)))))

(fn M.setup []
  (vim.api.nvim_create_user_command :ComposePreview preview-current {:desc "Run current @Preview with compose-preview"})
  (vim.api.nvim_create_user_command :ComposePreviewOpen open-tui {:desc "Open compose-preview TUI"})
  (vim.api.nvim_create_user_command :ComposePreviewList preview-list {:desc "List compose previews for current file"})
  (vim.api.nvim_create_user_command :ComposePreviewWeb preview-web {:desc "Open compose-preview web viewer"})
  (vim.api.nvim_create_user_command :ComposePreviewClear clear-cache {:desc "Clear compose-preview cache"})
  (vim.api.nvim_create_user_command :ComposePreviewStatus show-status {:desc "Show compose-preview status"})
  (vim.keymap.set :n :<leader>cpp preview-current {:desc "Run current @Preview"})
  (vim.keymap.set :n :<leader>cpa open-tui {:desc "Open compose-preview TUI"})
  (vim.keymap.set :n :<leader>cpl preview-list {:desc "List @Preview functions"})
  (vim.keymap.set :n :<leader>cpw preview-web {:desc "Open compose-preview web viewer"})
  (vim.keymap.set :n :<leader>cpc clear-cache {:desc "Clear compose-preview cache"})
  (vim.keymap.set :n :<leader>cpC show-status {:desc "Show compose-preview status"}))

M
