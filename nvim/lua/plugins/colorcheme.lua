-- return {
--     -- add dracula
--     { "Mofiqul/dracula.nvim" },
--
--     -- Configure LazyVim to load dracula
--     {
--         "LazyVim/LazyVim",
--         opts = {
--             colorscheme = "dracula",
--         },
--     },
-- }

-- return {
--     "EdenEast/nightfox.nvim",
--     priority = 1000, -- Make sure to load this before all the other start plugins
--     config = function()
--         -- Optional: Configure the theme (see below for options)
--         require("nightfox").setup({
--             options = {
--                 -- compiled = true, -- Check docs for usage, helpful for startup time
--                 transparent = false, -- Set to true if you want your terminal background
--             },
--         })
--
--         -- ACTIVATE THE THEME
--         vim.cmd.colorscheme("carbonfox")
--     end,
-- }
-- return {
--     {
--         "sainnhe/gruvbox-material",
--         lazy = false,
--         priority = 1000,
--         config = function()
--             -- 'original' palette = vivid colors (fixes the "washed" look)
--             -- 'material' palette = pastel/soft colors (default)
--             vim.g.gruvbox_material_palette = "original"
--
--             -- 'hard' background = darkest background, sharpest contrast
--             vim.g.gruvbox_material_background = "hard"
--
--             -- Enable bold/italic for code clarity
--             vim.g.gruvbox_material_enable_bold = 1
--             vim.g.gruvbox_material_enable_italic = 1
--
--             vim.cmd.colorscheme("gruvbox-material")
--         end,
--     },
-- }
return {
    {
        "luisiacc/gruvbox-baby",
        lazy = false,
        priority = 1000,
        config = function()
            -- Enable telescope theme integration
            vim.g.gruvbox_baby_telescope_theme = 1

            -- Optional: Enable transparent background for an ultra-crisp feel
            -- if your terminal handles the background color
            -- vim.g.gruvbox_baby_transparent_mode = 1

            vim.cmd.colorscheme("gruvbox-baby")
        end,
    },
}
