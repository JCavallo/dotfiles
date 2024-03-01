local M = {}

vim.api.nvim_create_user_command('Gblame',
  function()
    vim.cmd("Git blame -w -C -C")
  end,
  { nargs = 0 }
)

vim.api.nvim_create_user_command('GblameFull',
  function()
    vim.cmd("Git blame -w -C -C -C")
  end,
  { nargs = 0 }
)

return setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    end
  end
})
