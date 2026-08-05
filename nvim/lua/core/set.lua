-- Adding this so that the vim messages works
vim.opt.termguicolors = true

--Adding numbers and relative numbers to the left margin
vim.opt.number=true
vim.opt.relativenumber=true

--Adding scroll buffer
vim.opt.scrolloff=8

--Adding indent settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = {
  tab = '→ ',
  space = '.',
  trail = 'X'
}

--Auto-indentation
--vim.opt.autoindent=true
--vim.opt.smartindent=true
--vim.opt.cindent=true

--Adding a color on line 81 (to indicate lines that are too long) and changing
--the color of that column
vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg = 'darkgrey', bg = '#3c3c3c' })

--Setting the colorscheme
vim.cmd.colorscheme("catppuccin-frappe")

-- Use Catppuccin frappe base for the main editor
vim.api.nvim_set_hl(0, "Normal", { bg = "#303446" })

-- Use Catppuccin macchiato surface colors for floating windows so they stand out
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#24273a" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#24273a", fg = "#494d64" })
vim.api.nvim_set_hl(0, "FloatTitle", { bg = "#24273a", fg = "#8aadf4" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#292c3c" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#292c3c" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#24273a" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#24273a", fg = "#494d64" })
vim.api.nvim_set_hl(0, "TelescopeTitle", { bg = "#24273a", fg = "#8aadf4" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#24273a" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#24273a", fg = "#494d64" })
vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#24273a" })
vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { bg = "#24273a", fg = "#494d64" })

--Setting clipboard
vim.opt.clipboard = "unnamedplus"
