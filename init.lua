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
    "dracula/vim",
    name = "dracula",
    priority = 1000,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "nvimtools/none-ls.nvim",
  },
  {
    "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
  },
}

require("lazy").setup(plugins)

require("lualine").setup({
  options = {
    theme = "dracula",
  },
})

require("nvim-tree").setup()

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "javascript", "typescript", "html", "css", "python", "c" },
  indent = { enable = true },
  highlight = { enable = true },
})

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      "venv"
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

require("telescope").load_extension("ui-select")

local telescope_builtin = require("telescope.builtin")

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "tsserver", "html", "cssls", "emmet_ls", "pyright", "clangd" },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
  capabilities = cmp_capabilities
})
lspconfig.tsserver.setup({
  capabilities = cmp_capabilities
})
lspconfig.html.setup({
  capabilities = cmp_capabilities
})
lspconfig.cssls.setup({
  capabilities = cmp_capabilities
})
lspconfig.emmet_ls.setup({
  capabilities = { capabilities, cmp_capabilities },
  filetypes = { "html", "css", "javascript" },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
      },
    },
  },
})
lspconfig.pyright.setup({
  capabilities = cmp_capabilities
})
lspconfig.clangd.setup({
  capabilities = cmp_capabilities
})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black,

    null_ls.builtins.diagnostics.eslint_d,
  },
})

local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<Escape>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- Set Theme
vim.cmd("set termguicolors")

vim.cmd("colorscheme dracula")

-- Keymaps
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})

vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

-- vim.keymap.set("n", "<leader>af", "gg=G")
vim.keymap.set("n", "<leader>af", vim.lsp.buf.format, {})
