-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Save the current buffer before switching to a tmux pane

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

vim.opt.shiftwidth = 4;

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
	vim.hl.on_yank({
	    higroup = "IncSearch",
	    timeout = 200,
    })
    end,
})

vim.g.tmux_navigator_save_on_switch = 2
vim.g.autoformat = false
vim.diagnostic.config({ virtual_text = true })
