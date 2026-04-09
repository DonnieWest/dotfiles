(fn fold-level []
  (let [line (vim.fn.getline vim.v.lnum)]
    (if (or (line:match "^> diff") (line:match "^> Index"))
        ">1"
        (or (line:match "^> @@") (line:match "^> %d"))
        ">2"
        "=")))

{:fold_level fold-level}
