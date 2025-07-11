-- Catppuccin is a nice colorscheme that matches my desktop setup

return {
  "catppuccin/nvim", 
  name = "catppuccin", 
  priority = 1000 ,
  config = function()
    vim.cmd.colorscheme "catppuccin"
  end
}
