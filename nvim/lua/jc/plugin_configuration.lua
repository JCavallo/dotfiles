require'neuron'.setup({
  virtual_titles = true,
  mappings = true,
  run = nil, -- function to run when in neuron dir
  neuron_dir = "~/neuron", -- the directory of all of your notes, expanded by default (currently supports only one directory for notes, find a way to detect neuron.dhall to use any directory)
  leader = "gz", -- the leader key to for all mappings, remember with 'go zettel'
})

print(require'neuron'.config)

vim.api.nvim_set_keymap(
  "n", "gzn", [[<Cmd>lua require'neuron/cmd'.new_edit(require'neuron'.config.neuron_dir)<CR>]],
  {noremap = true})
