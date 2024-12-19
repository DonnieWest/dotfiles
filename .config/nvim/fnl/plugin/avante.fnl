(module plugin.avante
        {require {nvim aniseed.nvim lib avante_lib avante avante}})

(lib.load)
(avante.setup {:provider :ollama
               :auto_suggestions_provider :ollama
               :vendors {:ollama {:__inherited_from :openai
                                  :api_key_name ""
                                  :endpoint "http://127.0.0.1:11434/v1"
                                  :model "qwen2.5-coder:3b-large-ctx"}}})

