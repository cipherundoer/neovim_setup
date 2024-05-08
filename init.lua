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
				italic_comments = true,
				underline_links = true,
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
	"nvim-tree/nvim-tree.lua",
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


			vim.keymap.set({ 'n', 'x' }, '<space>q', function()
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
	ensure_installed = { 'rust_analyzer' },
	handlers = {
		lsp_zero.default_setup,
	}
})


local lspconfig = require('lspconfig')

-- typescript config
-- require("lspconfig")['tsserver'].setup({
--    capabilities = capabilities,
--  })


lspconfig.rust_analyzer.setup {
	 on_init = function(client, initialization_result)
    if client.server_capabilities then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.semanticTokensProvider = false  -- turn off semantic tokens
    end
  end,


	-- Create a command `:Format` local to the LSP buffer
	-- o
}


-- Global mappings.
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)


local api = require "nvim-tree.api"
vim.keymap.set('n', '<space>l', api.tree.toggle) 

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
		vim.keymap.set('n', '<space>;', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})


-- nvim-tree
-- pre-requisites 
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- pass to setup along with your other options
require("nvim-tree").setup()
--
-- general vim options
--highlight Normal guibg=none
--highlight NonText guibg=none
--highlight Normal ctermbg=none
--highlight NonText ctermbg=none
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- transparency for nvim-tree, cuz this thing ugly
vim.cmd('highlight NvimTreeNormal guibg=transparent')

set.tabstop = 4
set.scrolloff = 10
set.shiftwidth = 4
set.smarttab = true
set.softtabstop = 4
set.cc = "80"
set.number = true
set.relativenumber = true
set.clipboard = unnamedplus
set.swapfile = false
set.undofile = true
set.smartcase = true
set.breakindent = true
vim.signcolumn = 'yes'
vim.inccommand = 'split'
vim.cursorline = true
-- highlight incrementally
set.incsearch = true
-- insensitigve search unless \C is used or one more capital letters are
-- in the search query
set.ignorecase = true
vim.opt.smartcase = true
-- stop highlighting everything after a search
vim.cmd('set nohlsearch')
