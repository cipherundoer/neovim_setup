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
	-- color scheme
	{ "luisiacc/gruvbox-baby", priority = 1000},
	-- toggle commenting with a shortcut
	{ 'numToStr/Comment.nvim',lazy = false },
	--  mason to manage lsp servers
	"williamboman/mason.nvim",
	-- treesitter for syntax highlighting and proper formatting
	{ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
	-- lsp stuff
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'L3MON4D3/LuaSnip'},
	-- auto pairing
	{'windwp/nvim-autopairs', event = "InsertEnter",},
	-- telescope
	{'nvim-telescope/telescope.nvim', tag = '0.1.5'},
	-- dependency for telescope
	'nvim-lua/plenary.nvim',
})

-- color scheme stuff
vim.g.gruvbox_baby_function_style = "NONE"
vim.g.gruvbox_baby_keyword_style = "italic"

-- vim.g.gruvbox_baby_highlights = {Normal = {fg = "#123123", bg = "NONE", style="underline"}}
--
-- -- Enable telescope theme
-- vim.g.gruvbox_baby_telescope_theme = 1
-- Load the colorscheme
vim.cmd[[colorscheme gruvbox-baby]]
-- -------------------------------------


require "opey.cmp"
require "opey.keymaps"
require "opey.telescope"
-- to access pallete
-- vim.g.gruvbox_baby_highlights = {Normal = {fg = colors.orange}}

-- setup autopairs
require("nvim-autopairs").setup()
-- setup mason
require("mason").setup()
-- setup commenter
require("Comment").setup()

-- setup treesitter 
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "typescript", "vim", "vimdoc", "query" },
  run = ':TSUpdate',

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  lazy = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = false,
	additional_vim_regex_highlighting = false,
	use_languagetree = false,
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    }
}

-- lsp-zero will do all the work of getting completion up and running without having to install
-- a bizillion other plugins manually
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('lspconfig').rust_analyzer.setup({})

-- shortcut vim.opt to set
local set = vim.opt

-- set vim options
vim.o.background = "dark"
set.tabstop=4
set.shiftwidth=4
set.softtabstop=4
set.cc="80"
set.number=true
set.relativenumber=true
set.clipboard=unnamedplus
set.swapfile=false
