(fn load-host [destination]
  (let [hostname (or vim.env.NVIM_HOSTNAME (vim.uv.os_gethostname))
        host-path (vim.fs.joinpath destination
                                   :lua
                                   :custom
                                   :hosts
                                   (.. hostname :.lua))]
    (when (vim.uv.fs_stat host-path)
      (let [(chunk err) (loadfile host-path)]
        (if chunk
            (chunk)
            (error err))))))

{:load load-host}
