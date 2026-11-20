return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    event = "VeryLazy",
    opts = {
	options = {

	    mode = "buffers",
	    always_show_bufferline =true,
	    separator_style = "slant",

	},
	highlights = {
	    fill = { bg = "#282828" },
	    separator = { fg = "#282828" },
	    separator_visible = { fg = "#282828" },
	    separator_selected = {
		fg = "#282828",
		bg = "#504945",
	    },
	    buffer_selected = {
		fg = "#fabd2f",
		bg = "#504945",
		bold = true,
	    },
	    close_button_selected = {
		fg = "#fabd2f",
		bg = "#504945",
	    },
	    modified_selected = {
		fg = "#fabd2f",
		bg = "#504945",
	    },

	},
    },
    keys = {
	{"<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer"},
	{"<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer"},
	{"<leader>D", "<cmd>confirm bdelete<cr>", desc = "Delete buffer"},
    },
}
