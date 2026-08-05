--Mapping the leader and the exiting the file command
vim.g.mapleader = " "
-- Moving blocks of text with 'J' and 'K'
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Terminal mappings under <leader>t
vim.keymap.set("n", "<leader>tt", "<cmd>terminal<cr>", { noremap = true, silent = true, desc = "Terminal: Open in current window" })
vim.keymap.set("n", "<leader>tl", "<cmd>vsplit | wincmd L | terminal<cr>", { noremap = true, silent = true, desc = "Terminal: Open in vertical split (right)" })
vim.keymap.set("n", "<leader>tj", "<cmd>split | wincmd J | terminal<cr>", { noremap = true, silent = true, desc = "Terminal: Open in horizontal split (below)" })

-- In terminal mode, <C-q> returns to terminal normal mode; <C-c> still sends SIGINT
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Terminal: Return to normal mode" })

-- Auto-enter terminal insert mode when opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- When a terminal process exits, close the terminal window and return focus to the previous window
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function()
    pcall(vim.cmd, "close!")
  end,
})

-- LSP related commands
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true, silent = true, desc = 'LSP: Go to Declaration' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true, desc = 'LSP: References' })
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { noremap = true, silent = true, desc = 'LSP: Implementation' })
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'LSP: Type Definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover' })

-- Editing / LSP utilities under <leader>c
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { noremap = true, silent = true, desc = 'LSP: Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'LSP: Code Action' })

-- Formatting: conform.nvim maps <leader>cf

-- Diagnostics
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { noremap = true, silent = true, desc = 'Diagnostics: Previous' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { noremap = true, silent = true, desc = 'Diagnostics: Next' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { noremap = true, silent = true, desc = 'Diagnostics: Line diagnostics' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true, desc = 'Diagnostics: Populate loclist' })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = 'LSP: Signature help' })

-- remapping <C-i> to <C-p> so that I can use <C-i> for harpoon and <C-p> for going forward on list jump
vim.keymap.set('n', '<C-p>', '<C-i>', { desc = 'Jumplist: Forward' })
