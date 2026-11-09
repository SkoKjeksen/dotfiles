return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
	require("nvim-treesitter").install({ "lua", "tsx", "typescript", "c", "cpp", "python", "rust" })
	vim.api.nvim_create_autocmd("FileType", {
	    group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
	    callback = function(event)
		local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
		if language and vim.treesitter.language.add(language) then
		    vim.treesitter.start(event.buf, language)
		    if vim.treesitter.query.get(language, "indents") then
			vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		    end
		end
	    end,
	})
    end
}
