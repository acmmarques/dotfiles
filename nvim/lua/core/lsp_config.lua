vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('cssls')
vim.lsp.enable('ruby_lsp')
vim.lsp.enable('herb_ls')
vim.lsp.enable('html')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('omnisharp')

-- For lsp purposes, I'll turn every eruby filetype into
-- a eruby.html filetype -> so that lsp works for html too
vim.cmd([[
  autocmd BufRead,BufNewFile *.erb set filetype=eruby.html
]])
