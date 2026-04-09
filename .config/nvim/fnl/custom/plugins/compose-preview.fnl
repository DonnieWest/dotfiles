{1 :nvim-treesitter/nvim-treesitter
 :dependencies [:nvim-lua/plenary.nvim]
 :ft [:kotlin]
 :config (fn []
          (local M {})
          (local api vim.api)
          (local vimfn vim.fn)
          (local uv vim.uv)
          
          ;; State
          (local state {:auto_preview_enabled true
                        :preview_window nil
                        :last_manifest nil
                        :cache_dir (.. (vimfn.stdpath :cache) "/compose-preview")})
          
          ;; Ensure cache directory exists
          (fn ensure_cache_dir []
            (when (not (uv.fs_stat state.cache_dir))
              (uv.fs_mkdir state.cache_dir 493)))
          
          ;; Find Android project root
          (fn find_project_root []
            (let [cwd (vimfn.getcwd)]
              (var dir cwd)
              (while (and (not (= dir "/"))
                          (not (or (uv.fs_stat (.. dir "/gradlew"))
                                   (uv.fs_stat (.. dir "/build.gradle"))
                                   (uv.fs_stat (.. dir "/build.gradle.kts")))))
                (set dir (vim.fs.dirname dir)))
              (when (not (= dir "/"))
                dir)))
          
          ;; Parse @Preview functions using tree-sitter (with regex fallback)
          (fn get_previews []
            (var previews [])
            (let [bufnr (api.nvim_get_current_buf)
                  (ok parser) (pcall vim.treesitter.get_parser bufnr :kotlin)]
              (if ok
                  ;; Tree-sitter path
                  (let [tree (parser:parse)
                        root (do
                               (let [first-tree (. tree 1)]
                                 (first-tree:root)))
                        query (vim.treesitter.query.parse :kotlin
                                "(function_definition\n  (modifiers\n    (annotation\n      (user_type\n        (type_identifier) @annotation_name\n        (#eq? @annotation_name \"Preview\"))))\n  (simple_identifier) @preview_function\n  body: (function_body) @preview_body) @preview_node)")]
                    (each [id node _ (query:iter_captures root bufnr)]
                      (when (= (. query.captures id) :preview_function)
                        (let [func_name (vim.treesitter.get_node_text node bufnr)
                              start_row (node:start)
                              end_row (node:end)]
                           (table.insert previews
                                         {:function func_name
                                          :file (vimfn.expand "%:t")
                                          :file_path (vimfn.expand "%:p")
                                          :line (+ start_row 1)
                                          :end_line (+ end_row 1)})))))
                  ;; Fallback: regex-based detection
                  (do
                    (var in_preview false)
                    (var current_line nil)
                    (each [idx line (ipairs (api.nvim_buf_get_lines bufnr 0 -1 false))]
                      (when (line:match "@Preview")
                        (set in_preview true)
                        (set current_line idx))
                      (when in_preview
                        (let [func_match (line:match "fun%s+([a-zA-Z_][a-zA-Z0-9_]*)")]
                          (when func_match
                            (table.insert previews
                                          {:function func_match
                                           :file (vimfn.expand "%:t")
                                           :file_path (vimfn.expand "%:p")
                                           :line (or current_line idx)
                                           :end_line idx})
                            (set in_preview false)
                            (set current_line nil))))))))
              previews)
          
          ;; Get preview at cursor
          (fn get_preview_at_cursor []
            (let [cursor_pos (api.nvim_win_get_cursor 0)
                  cursor_line (. cursor_pos 1)
                  previews (get_previews)]
              (var result nil)
              (each [_ preview (ipairs previews)]
                (when (and (>= cursor_line preview.line)
                           (<= cursor_line preview.end_line))
                  (set result preview)))
              result))
          
          ;; Generate manifest JSON file
          (fn generate_manifest [previews ?project_root]
            (let [project_root (or ?project_root (find_project_root))]
              (when project_root
                (let [manifest_path (.. project_root "/build/preview-manifest.json")
                      file_path (vimfn.expand "%:p")
                      parts (vim.split file_path "/src/")
                      package_name (when (> (length parts) 1)
                                     (let [src_part (. parts 2)
                                           kotlin_parts (vim.split src_part "/kotlin/")]
                                       (when (> (length kotlin_parts) 1)
                                         (-> (. kotlin_parts 2)
                                             (string.sub 1 -5)
                                             (string.gsub "/" ".")))))
                      manifest {:previews previews
                                :packageName (or package_name "preview")
                                :generatedAt (os.time)}]
                  (let [manifest_dir (vimfn.fnamemodify manifest_path ":h")]
                    (when (not (uv.fs_stat manifest_dir))
                      (uv.fs_mkdir manifest_dir 493)))
                  (vimfn.writefile [(vim.json.encode manifest)] manifest_path)
                  (set state.last_manifest manifest_path)
                  manifest_path))))
          
          ;; Display image in floating window using Sixel
          (fn display_preview [png_path]
            (ensure_cache_dir)
            (when state.preview_window
              (pcall api.nvim_buf_delete state.preview_window.bufnr {:force true}))
            (if (uv.fs_stat png_path)
                (let [width 80
                      height 30
                      bufnr (api.nvim_create_buf false true)
                      win_opts {:relative :editor
                                :width width
                                :height height
                                :row 3
                                :col (math.floor (/ (- (vim.o.columns) width) 2))
                                :style :minimal
                                :border :rounded
                                :title (.. " Preview: " (vimfn.fnamemodify png_path ":t:r"))
                                :title_pos :center}
                      winnr (api.nvim_open_win bufnr true win_opts)]
                  (api.nvim_set_option_value :filetype :compose-preview {:buf bufnr})
                  (api.nvim_set_option_value :modifiable true {:buf bufnr})
                  (tset state :preview_window {:bufnr bufnr :winnr winnr})
                  (api.nvim_buf_call bufnr
                    (fn []
                      (vimfn.termopen ["img2sixel" png_path]
                                  {:on_exit (fn []
                                             (api.nvim_set_option_value :modifiable false {:buf bufnr}))})))
                  (api.nvim_buf_set_keymap bufnr :n "q" ":close<CR>" {:silent true :noremap true})
                  (api.nvim_buf_set_keymap bufnr :n "<Esc>" ":close<CR>" {:silent true :noremap true}))
                (vim.notify (.. "Preview image not found: " png_path) :error {:title :ComposePreview})))
          
          ;; Display placeholder when no image available
          (fn display_placeholder [preview_name]
            (let [width 60
                  height 15
                  bufnr (api.nvim_create_buf false true)
                  lines ["" "  ╔════════════════════════════════════════════════════╗" "  ║                                                    ║"
                         (.. "  ║  Preview: " preview_name (string.rep " " (- 40 (length preview_name))) "║")
                         "  ║                                                    ║" "  ║  No image generated yet.                           ║"
                         "  ║                                                    ║" "  ║  Run :ComposePreview or press <leader>cpp         ║"
                         "  ║  to generate the preview image.                    ║" "  ║                                                    ║"
                         "  ╚══════════════════════════════════════════════════╝" ""]
                  win_opts {:relative :editor
                            :width width
                            :height height
                            :row 5
                            :col (math.floor (/ (- (vim.o.columns) width) 2))
                            :style :minimal
                            :border :rounded
                            :title (.. " " preview_name " ")
                            :title_pos :center}
                  winnr (api.nvim_open_win bufnr true win_opts)]
              (api.nvim_buf_set_lines bufnr 0 -1 true lines)
              (api.nvim_set_option_value :modifiable false {:buf bufnr})
              (api.nvim_buf_set_keymap bufnr :n "q" ":close<CR>" {:silent true :noremap true})
              (api.nvim_buf_set_keymap bufnr :n "<Esc>" ":close<CR>" {:silent true :noremap true})))
          
          ;; Run preview generation task
          (fn run_preview_generation [preview ?callback]
            (let [project_root (find_project_root)
                  previews (if preview [preview] (get_previews))]
              (when (and project_root (> (length previews) 0))
                (let [manifest_path (generate_manifest previews project_root)]
                  (when manifest_path
                    (vim.notify "Generating preview..." :info {:title :ComposePreview})
                    (vimfn.jobstart ["adc" "preview" "generate" "--manifest" manifest_path]
                                {:on_stdout (fn [_ data]
                                             (each [_ line (ipairs data)]
                                               (when (and line (not (= line "")))
                                                 (print line))))
                                 :on_stderr (fn [_ data]
                                             (each [_ line (ipairs data)]
                                               (when (and line (not (= line "")))
                                                 (vim.notify line :error {:title :ComposePreview}))))
                                 :on_exit (fn [_ code]
                                           (if (= code 0)
                                               (do
                                                 (vim.notify "Preview generated!" :info {:title :ComposePreview})
                                                 (when ?callback (?callback)))
                                               (vim.notify "Preview generation failed" :error {:title :ComposePreview})))}))))))
          
          ;; Find preview image
          (fn find_preview_image [preview_name ?project_root]
            (let [project_root (or ?project_root (find_project_root))]
              (when project_root
                (let [possible_paths [(.. project_root "/app/build/outputs/compose-preview/" preview_name ".png")
                                      (.. project_root "/build/outputs/compose-preview/" preview_name ".png")
                                      (.. project_root "/app/build/reports/paparazzi/images/" preview_name ".png")]]
                  (var found nil)
                  (each [_ path (ipairs possible_paths) :until found]
                    (when (uv.fs_stat path)
                      (set found path)))
                  found))))
          
          ;; Public API: Preview current @Preview function
          (fn preview_current []
            (let [preview (get_preview_at_cursor)]
              (if preview
                  (run_preview_generation preview
                    (fn []
                      (let [img_path (find_preview_image preview.function)]
                        (if img_path
                            (display_preview img_path)
                            (display_placeholder preview.function)))))
                  (vim.notify "No @Preview function found at cursor" :warn {:title :ComposePreview}))))
          
          ;; Public API: Preview all @Preview functions in file
          (fn preview_all []
            (let [previews (get_previews)]
              (if (> (length previews) 0)
                  (run_preview_generation nil
                    (fn []
                      (if (= (length previews) 1)
                          (let [preview (.
                                         previews
                                         1)
                                img_path (find_preview_image preview.function)]
                            (if img_path
                                (display_preview img_path)
                                (display_placeholder preview.function)))
                          (let [items (icollect [_ p (ipairs previews)] p.function)]
                            (vim.ui.select items
                              {:prompt "Select preview to display: "}
                              (fn [choice]
                                (when choice
                                  (let [img_path (find_preview_image choice)]
                                    (if img_path
                                        (display_preview img_path)
                                        (display_placeholder choice))))))))))
                  (vim.notify "No @Preview functions found in current file" :warn {:title :ComposePreview}))))
          
          ;; Public API: List all @Preview functions
          (fn preview_list []
            (let [previews (get_previews)]
              (if (> (length previews) 0)
                  (vim.ui.select (icollect [_ p (ipairs previews)]
                                   (.. p.function " (line " p.line ")"))
                                 {:prompt "Preview functions: "}
                                 (fn [choice idx]
                                   (when choice
                                     (let [preview (. previews idx)]
                                       (api.nvim_win_set_cursor 0 {preview.line 0})
                                       (preview_current)))))
                  (vim.notify "No @Preview functions found" :warn {:title :ComposePreview}))))
          
          ;; Public API: Toggle auto-preview on save
          (fn toggle_auto_preview []
            (set state.auto_preview_enabled (not state.auto_preview_enabled))
            (vim.notify (.. "Auto-preview " (if state.auto_preview_enabled "enabled" "disabled"))
                       :info {:title :ComposePreview}))
          
          ;; Public API: Clear preview cache
          (fn clear_cache []
            (vimfn.jobstart ["adc" "preview" "clean"]
                        {:on_exit (fn []
                                   (vim.notify "Preview cache cleared" :info {:title :ComposePreview}))}))
          
          ;; Public API: Show preview status
          (fn show_status []
            (vimfn.jobstart ["adc" "preview" "status"]
                        {:on_stdout (fn [_ data]
                                     (each [_ line (ipairs data)]
                                       (when (and line (not (= line "")))
                                         (print line))))}))
          
          ;; Setup autocommands
          (local augroup (api.nvim_create_augroup :ComposePreview {:clear true}))
          
          ;; Auto-preview on save (debounced)
          (local debounce_timer {:timer nil})
          (fn debounced_preview []
            (when debounce_timer.timer
              (debounce_timer.timer:stop))
            (set debounce_timer.timer (uv.new_timer))
            (debounce_timer.timer:start 1000 0
              (vim.schedule_wrap
                (fn []
                  (when (and state.auto_preview_enabled (find_project_root))
                    (let [previews (get_previews)]
                      (when (> (length previews) 0)
                        (run_preview_generation nil))))
                  (when debounce_timer.timer
                    (debounce_timer.timer:stop)
                    (set debounce_timer.timer nil))))))
          
          (api.nvim_create_autocmd :BufWritePost
                                   {:group augroup
                                    :pattern ["*.kt" "*.kts"]
                                    :callback debounced_preview})
          
          ;; Register user commands
          (api.nvim_create_user_command :ComposePreview preview_current {:desc "Generate and display Compose preview"})
          (api.nvim_create_user_command :ComposePreviewAll preview_all {:desc "Generate all previews in file"})
          (api.nvim_create_user_command :ComposePreviewList preview_list {:desc "List all @Preview functions"})
          (api.nvim_create_user_command :ComposePreviewToggle toggle_auto_preview {:desc "Toggle auto-preview on save"})
          (api.nvim_create_user_command :ComposePreviewClear clear_cache {:desc "Clear preview cache"})
          (api.nvim_create_user_command :ComposePreviewStatus show_status {:desc "Show preview status"})
          
          ;; Keybindings
          (vim.keymap.set :n :<leader>cpp preview_current {:desc "Preview current @Preview function"})
          (vim.keymap.set :n :<leader>cpa preview_all {:desc "Preview all @Preview functions"})
          (vim.keymap.set :n :<leader>cpl preview_list {:desc "List @Preview functions"})
          (vim.keymap.set :n :<leader>cpt toggle_auto_preview {:desc "Toggle auto-preview on save"})
          (vim.keymap.set :n :<leader>cpc clear_cache {:desc "Clear preview cache"})
          (vim.keymap.set :n :<leader>cpC show_status {:desc "Show preview configuration"})
          
          ;; Export module functions
          (tset _G :ComposePreview {:preview_current preview_current
                                    :preview_all preview_all
                                    :preview_list preview_list
                                    :toggle_auto_preview toggle_auto_preview
                                    :clear_cache clear_cache
                                    :show_status show_status
                                    :get_previews get_previews}))}
