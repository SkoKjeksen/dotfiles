return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    { -- TELESCOPE ---
      "nvim-telescope/telescope.nvim",
      tag= "0.1.4",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local telescope = require("telescope")
        telescope.setup({})
        local b = require("telescope.builtin")
        vim.keymap.set('n', '<leader>ff', b.find_files, { desc = "Find Files"})
        vim.keymap.set('n', '<leader>fg', b.live_grep, { desc = "Live Grep"})
        vim.keymap.set('n', '<leader>fb', b.buffers, { desc = "Find Buffers"})
        vim.keymap.set('n', '<leader>fh', b.help_tags, { desc = "Find Help"})
    end

  }
}
