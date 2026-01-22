;; Rustaceanvim - Modern Rust tooling
;; Provides rust-analyzer integration with clippy, type hints, and debugging
{1 :mrcjkb/rustaceanvim
 :version :^5
 :ft :rust
 :config (fn []
           (set vim.g.rustaceanvim
                {:server {:settings {:rust-analyzer {:check {:command :clippy}
                                                     :cargo {:features :all}
                                                     :procMacro {:enable true}}}}
                 :tools {:hover_actions {:replace_builtin_hover true}}}))}
