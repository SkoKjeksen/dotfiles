-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable arrow keys in normal mode (force hjkl)
vim.keymap.set("n", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<Right>", "<Nop>", { noremap = true, silent = true })

-- Disable arrow keys in insert mode (hardcore mode)
-- vim.keymap.set("i", "<Up>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<Down>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<Left>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<Right>", "<Nop>", { noremap = true, silent = true })

-- Disable arrow keys in visual mode
vim.keymap.set("v", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("v", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("v", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("v", "<Right>", "<Nop>", { noremap = true, silent = true })

vim.keymap.set("i", "jj", "<Esc>")

-- Disable line joining (ANNOYING)
vim.keymap.set("n", "J", "<Nop>", { noremap = true, silent = true}) 
