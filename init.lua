local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
	"hrsh7th/cmp-nvim-lsp-signature-help",
	-- color scheme
	{
		-- Theme inspired by Atom
		'Mofiqul/vscode.nvim',
		priority = 1000,
		lazy = false,
		config = function()
			require('vscode').setup {
				transparent = true,
			}
			require('vscode').load()
		end,
	},
	-- toggle commenting with a shortcut
	{ 'numToStr/Comment.nvim',     lazy = false },
	--  mason to manage lsp servers
	"williamboman/mason.nvim",
	-- lsp stuff
	{ 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp'

	},
	{ 'L3MON4D3/LuaSnip' },
	-- auto pairing
	{ 'windwp/nvim-autopairs',         event = "InsertEnter", },
	-- telescope
	{ 'nvim-telescope/telescope.nvim', tag = '0.1.5' },
	-- dependency for telescope
	'nvim-lua/plenary.nvim',
	{ -- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = 'vscode',
				component_separators = '|',
				section_separators = '',
			},
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end
	},

	"williamboman/mason-lspconfig.nvim",
})

--
require 'cmp'.setup {
	sources = {
		{ name = 'nvim_lsp_signature_help' }
	}
}

require "opey.cmp"
require "opey.keymaps"
require "opey.telescope"

-- setup autopairs
require("nvim-autopairs").setup()
-- setup commenter
require("Comment").setup()


-- lsp-zero will do all the work of getting completion up and running without having to install
-- a bizillion other plugins manually
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	local opts = { buffer = bufnr }

	vim.keymap.set({ 'n', 'x' }, 'pq', function()
		vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
	end, opts)
end)

lsp_zero.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})


-- setup mason
require("mason").setup({})
require('mason-lspconfig').setup({
	-- Replace the language servers listed here
	-- with the ones you want to install
	ensure_installed = { 'tsserver', 'rust_analyzer' },
	handlers = {
		lsp_zero.default_setup,
	}
})
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
	on_attach = function(client, bufnr)
		client.server_capabilities.semanticTokensProvider = nil
		-- I'm guessing for now that treesitter is doing this for me
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentFormattingRangeProvider = true
	end,

	-- Create a command `:Format` local to the LSP buffer
}


-- Global mappings.
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

local set = vim.opt
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})


-- set vim options
vim.o.background = "dark"
set.tabstop = 4
set.shiftwidth = 4
set.smartcase = true
set.smarttab = true
set.softtabstop = 4
set.cc = "80"
set.number = true
set.relativenumber = true
set.clipboard = unnamedplus
set.swapfile = false
set.swapfile = false
