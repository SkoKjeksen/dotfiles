return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    event = "VeryLazy",
    opts = {
	options = {

	    mode = "buffers",
	    always_show_bufferline = true,
	},
    },
    keys = {
	{"<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer"},
	{"<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer"},
	{"<leader>D", "<cmd>confirm bdelete<cr>", desc = "Delete buffer"},
    },
}
