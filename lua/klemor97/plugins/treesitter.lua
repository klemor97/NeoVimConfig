return {
  "nvim-treesitter/nvim-treesitter", 
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "c", "cpp", "javascript", "typescript" },
      indent = { enable = true },
      highlight = { enable = true }
    })
  end
}
