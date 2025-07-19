return {
	"numToStr/FTerm.nvim",
	config = function()
		require("FTerm").setup({
			border = "rounded",
		})

		vim.keymap.set("n", "<A-i>", require("FTerm").toggle, { desc = "Toggle FTerm" })
		vim.keymap.set("t", "<A-i>", require("FTerm").toggle, { desc = "Toggle FTerm" })
	end,
}
