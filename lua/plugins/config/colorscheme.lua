local status_ok, dracula = pcall(require, "dracula")
if not status_ok then
	return
end

dracula.setup({
	colors = {
		bg = "#0A0A0A",
	},
	show_end_of_buffer = false,
	transparent_bg = false,
	lualine_bg_color = nil,
	italic_comment = true,
})

vim.cmd.colorscheme("dracula")