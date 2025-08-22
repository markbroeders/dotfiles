-- CUSTOM MAPPINGS
-- could add a helper function, maybe in the future

-- TELESCOPE
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><Space>", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" }) -- Find files
-- Find files in .config
vim.keymap.set("n", "<leader>fc", function()
	builtin.find_files({ cwd = "~/.dotfiles/config/" })
end, { desc = "Telescope find files" })
-- Find python projects
vim.keymap.set("n", "<leader>fp", function()
	builtin.find_files({ cwd = "~/Development/python/" })
end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>") -- Search or create note
vim.keymap.set("n", "<leader>.", builtin.buffers, { desc = "Telescope buffers" })

-- More buffer management
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Delete buffer" })

-- OPEN FILES
vim.keymap.set("n", "<leader>oi", ":e $HOME/Documenten/inbox.md<CR>", { desc = "Open Inbox" })

-- NOTE TAKING
vim.keymap.set(
	"n",
	"<leader>on",
	":Telescope file_browser path=~/Documenten/Notes/<CR>",
	{ desc = "Search or create note" }
) -- Search or create note

-- VARIOUS
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
-- Folding hack
-- Somehow the folding markdown script sets folding so that when I open files
-- most blocks are folded. This is not the behavior I want! Since I don't know
-- how to fix this, I've disabled folding in the init.lua file. I'll bind a
-- keybinding to enable and disable folding.
vim.keymap.set("n", "<leader>ef", ":set foldenable<CR>", { desc = "Enable folding" })
vim.keymap.set("n", "<leader>df", ":set nofoldenable<CR>", { desc = "Disable folding" })
-- Formatting
vim.keymap.set("n", "<leader>fmi", ":GuessIndent<CR>", { desc = "Indentation" })

-- PRODUCTIVITY SECTION
-- Capture a todo
vim.keymap.set("n", "<leader>ct", function()
	local script = vim.fn.expand("~/.config/scripts/todo.sh")
	require("FTerm").scratch({ cmd = "bash " .. script })
end, { desc = "Run todo.sh in FTerm" })
-- Toggle a checkbox
vim.keymap.set("n", "<leader>tt", ":ToggleCheckbox<CR>", { desc = "Toggle Checkbox" })

-- JOURNAL
local journal_base = vim.fn.expand("~/Documenten/Journal")

-- Helper functie om journal te openen
local function open_journal(date)
	local year = string.sub(date, 1, 4)
	local path = journal_base .. "/" .. year
	local filename = path .. "/" .. date .. ".md"

	-- Maak de map aan als deze nog niet bestaat
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
	end

	-- Voeg header toe als bestand nog niet bestaat
	if vim.fn.filereadable(filename) == 0 then
		local header = "# " .. date .. "\n\n"
		local file = io.open(filename, "w")
		if file then
			file:write(header)
			file:close()
		end
	end

	-- Voeg subheader met tijd toe bij openen
	local current_time = os.date("%H:%M")
	local file = io.open(filename, "a")
	if file then
		file:write("## " .. current_time .. "\n\n")
		file:close()
	end

	vim.cmd("edit " .. filename)
end

-- Keymap voor journal van vandaag
vim.keymap.set("n", "<leader>jt", function()
	local today = os.date("%Y-%m-%d")
	open_journal(today)
end, { desc = "Open today's journal" })

-- Keymap voor journal van gisteren
vim.keymap.set("n", "<leader>jy", function()
	local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
	open_journal(yesterday)
end, { desc = "Open yesterday's journal" })

-- Add a journal entry from within Neovim
vim.keymap.set("n", "<leader>jj", function()
	local script = vim.fn.expand("~/.config/scripts/journal.py")
	require("FTerm").scratch({ cmd = "python " .. script })
end, { desc = "Add journal entry from within FTerm" })

-- PLAYGROUND
