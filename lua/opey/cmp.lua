local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

-- completion is working with the below keybindings
cmp.setup({
	completion = {
		completeopt = 'menu,menuone,noinsert',
	},
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		-- ['<C-Space>'] = cmp.mapping.complete(),
		['C-e'] = cmp.mapping.abort(),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		['<C-]>'] = cmp.mapping.select_prev_item(),
		['<C-\\>'] = cmp.mapping.select_next_item(),

		-- Scroll up and down in the completion documentation
		['C-f'] = cmp.mapping.scroll_docs(-4),
		['C-d'] = cmp.mapping.scroll_docs(4),
	}),
	-- nvim_lsp apparently retrieves the completion data from the LSPs
	sources = {
		{ name = 'nvim_lsp'},
		{ name = 'path'},
	},
})
