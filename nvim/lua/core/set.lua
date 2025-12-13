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

--Different tabs for C files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "make" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false
  end,
})

--Auto-indentation
--vim.opt.autoindent=true
--vim.opt.smartindent=true
--vim.opt.cindent=true

--Adding a color on line 81 (to indicate lines that are too long) and changing
--the color of that column
vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg = 'darkgrey', bg = '#3c3c3c' })

--Setting the colorscheme
vim.cmd.colorscheme("catppuccin")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { bg = "none" })

--Setting clipboard
vim.opt.clipboard = "unnamedplus"
