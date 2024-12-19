(module plugin.cmp-ai {require {nvim aniseed.nvim ai cmp_ai.config}})


(ai:setup {:max_lines 100
           :notify true
           :notify_callback (fn [msg] (vim.notify msg))
           :provider :Ollama
           :provider_options {:model "qwen2.5-coder:3b-large-ctx"
                              :prompt (fn [lines-before lines-after]
                                        (.. :<|fim_prefix|> lines-before
                                            :<|fim_suffix|> lines-after
                                            :<|fim_middle|>))}
           :run_on_every_keystroke false})
