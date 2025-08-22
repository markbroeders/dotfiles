-- A collection of various plugins
return {
	{
		"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically
		config = function()
			require("guess-indent").setup({})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
