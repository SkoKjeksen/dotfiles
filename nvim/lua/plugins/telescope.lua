return {
    "nvim-telescope/telescope.nvim", tag = "v0.2.2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope-file-browser.nvim" },
    config = function()
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
	vim.keymap.set("n", "<leader>fw", function()
	    builtin.live_grep({
		word_match = "-w",
		default_text = vim.fn.expand("<cword>"),
	    })
	end, { desc = "Live grep word under cursor" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    end
}
