-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Syntax Highlighting
vim.cmd("syntax on")

-- Error Bells
vim.cmd("set noerrorbells")

-- Text Wrap
vim.cmd("set nowrap")

-- Scrolloff
vim.cmd("set scrolloff=8")

-- Indentation
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.cmd("set autoindent")

-- Line Numbers
vim.cmd("set number")
vim.cmd("set relativenumber")

-- Swap & Backup Files
vim.cmd("set noswapfile")
vim.cmd("set nobackup")

-- Leader Key
vim.g.mapleader = " "

-- Lazy Setup
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

local plugins = {
  {
    "dracula/vim", name = "dracula", priority = 1000
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "nvim-tree/nvim-tree.lua",
	  dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  {
    "nvim-treesitter/nvim-treesitter", build = ":TSUpdate"
  },
  {
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim"
  },
  {
    "williamboman/mason.nvim"
  },
  {
    "williamboman/mason-lspconfig.nvim"
  },
  {
    "neovim/nvim-lspconfig"
  }
}

require("lazy").setup(plugins)

require("lualine").setup({
  options = {
    theme = "dracula"
  }
})

require("nvim-tree").setup()

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "javascript", "typescript", "html", "css" },
  indent = { enable = true },
  highlight = { enable = true }
})

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({})
    }
  }
})

require("telescope").load_extension("ui-select")

local telescope_builtin = require("telescope.builtin")

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "tsserver", "html", "cssls", "emmet_ls" }
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
lspconfig.tsserver.setup({})
lspconfig.html.setup({})
lspconfig.cssls.setup({})
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { "html", "css", "javascript" },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true
      }
    }
  }
})

-- Set Theme
vim.cmd("set termguicolors")

vim.cmd("colorscheme dracula")

-- Keymaps
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>af", "gg=G")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})

vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
