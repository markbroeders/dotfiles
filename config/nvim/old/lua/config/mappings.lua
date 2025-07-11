-- Mapping helper
---@param mode string
---@param key string
---@param result function | string
---@param desc? string
local mapper = function(mode, key, result, desc) vim.keymap.set(mode, key, result, { noremap = true, silent = true, desc = desc }) end

mapper("i", "jj", "<Esc>")

-- Buffer management
mapper("n", "<Leader>bn", ":bn<CR>", "Next buffer")
mapper("n", "<Leader>bp", ":bp<CR>", "Prev buffer")
mapper("n", "<Leader>bd", ":bp | bd #<CR>", "Delete current buffer")
-- Tab management
mapper("n", "<Leader>tn", "<cmd>tabn<CR>", "Next tab");
mapper("n", "<Leader>tp", "<cmd>tabp<CR>", "Prev tab");
mapper("n", "<Leader>tq", "<cmd>tabcl<CR>", "Close tab");

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><space>', builtin.buffers, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
vim.keymap.set('n', '<leader><space>', builtin.buffers, {})

-- Neotree
vim.keymap.set('n', '<leader>nt', ':Neotree filesystem reveal left<CR>')
