(module plugin.avante
        {require {nvim aniseed.nvim lib avante_lib avante avante}})

(lib.load)
(avante.setup {:provider :ollama
               :auto_suggestions_provider :ollama
               :behavior {:auto_suggestions true
                          :auto_set_highlight_group true
                          :auto_set_keymaps true
                          :auto_apply_diff_after_generation false
                          :support_paste_from_clipboard false
                          :minimize_diff true}
               :vendors {:ollama {:__inherited_from :openai
                                  :api_key_name ""
                                  :endpoint "http://127.0.0.1:11434/v1"
                                  :model "llama3.2:claude3b"}}})

