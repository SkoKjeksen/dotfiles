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
