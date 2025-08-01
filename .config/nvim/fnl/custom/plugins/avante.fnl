{1 :yetone/avante.nvim
 :build :make
 :dependencies [:stevearc/dressing.nvim
                :nvim-lua/plenary.nvim
                :MunifTanjim/nui.nvim
                :echasnovski/mini.pick
                :nvim-telescope/telescope.nvim
                :hrsh7th/nvim-cmp
                :ibhagwan/fzf-lua
                :nvim-tree/nvim-web-devicons
                :zbirenbaum/copilot.lua
                {1 :HakonHarnes/img-clip.nvim
                 :event :VeryLazy
                 :opts {:default {:drag_and_drop {:insert_mode true}
                                  :embed_image_as_base64 false
                                  :prompt_for_file_name false
                                  :use_absolute_path true}}}
                {1 :MeanderingProgrammer/render-markdown.nvim
                 :ft [:markdown :Avante]
                 :opts {:file_types [:markdown :Avante]}}]
 :event :VeryLazy
 :lazy false
 :opts {:providers {:openai {:endpoint "https://openrouter.ai/api/v1"}
                    :max_tokens 4096
                    :model :deepseek/deepseek-r1-distill-llama-70b:free
                    :temperature 0
                    :timeout 30000}
        :provider :openai}
 :version false}
