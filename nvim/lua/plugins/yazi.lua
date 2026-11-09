---@type LazySpec
return {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
	{ "nvim-lua/plenary.nvim", lazy = true },
    },
    vim.keymap.set("n", "<leader>cd", "<cmd>Yazi cwd<cr>", { desc = "Open Yazi in current working directory" })
}
