return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		filesystem = {
			filtered_items = {
				visible = true, -- show “hidden” items (they’ll be dimmed)
				hide_dotfiles = false, -- don’t hide dotfiles
				hide_gitignored = false, -- (optional) show .gitignored too
				-- show_hidden_count = true, -- optional
			},
		},
	},
}
