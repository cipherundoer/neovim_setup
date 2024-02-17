local mappings = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- keymappings to center searching to the center of the buffer
keymap("n", "n", "nzz", mappings)
keymap("n", "N", "Nzz", mappings)


-- keymappings for telescope
require("opey.telescope")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- keymappings for diagnostics 
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

