{1 :carlos-algms/agentic.nvim
 :opts {:provider :gemini-acp}
 :keys [{1 "<C-\">"
         2 (fn []
             ((. (require :agentic) :toggle)))
         :mode [:n :v :i]
         :desc "Toggle Agentic Chat"}
        {1 "<C-'>"
         2 (fn []
             ((. (require :agentic) :add_selection_or_file_to_context)))
         :mode [:n :v]
         :desc "Add file or selection to Agentic to Context"}
        {1 "<C-,>"
         2 (fn []
             ((. (require :agentic) :new_session)))
         :mode [:n :v :i]
         :desc "New Agentic Session"}]}
