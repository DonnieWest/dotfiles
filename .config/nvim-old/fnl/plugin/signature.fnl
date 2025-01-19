(module plugin.signature
        {require {nvim aniseed.nvim lsp-signature lsp_signature}})

(lsp-signature.setup {:bind true :floating_window false :hint_prefix ""})

