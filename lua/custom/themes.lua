return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.catppuccin_flavour = "mocha"
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          treesitter = true,
          native_lsp = { enabled = true },
        },
      })
      -- vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "xero/miasma.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme miasma")
    end,
  },
}
