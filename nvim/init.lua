-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.mapleader = " "
require("config.options")
require("config.keybinds")
require("config.lazy")

-- vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
-- vim.cmd [[ hi NormalNC guibg=NONE ctermbg=NONE ]]
