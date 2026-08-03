local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config("lua_ls", { capabilities = capabilities })
vim.lsp.config("html", { capabilities = capabilities })
vim.lsp.config("cssls", { capabilities = capabilities })
vim.lsp.config("tailwindcss", { capabilities = capabilities })
vim.lsp.config("basedpyright", { capabilities = capabilities })
vim.lsp.config("ts_ls", { capabilities = capabilities })
vim.lsp.config("bashls", { capabilities = capabilities })

vim.lsp.enable("lua_ls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("basedpyright")
vim.lsp.enable("ts_ls")
vim.lsp.enable("bashls")
