local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.catppuccin_flavour = "mocha"
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          treesitter = true,
          native_lsp = { enabled = true },
        },
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "nvim-mini/mini.clue",
    event = "VimEnter",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          { mode = { "n", "x" }, keys = "<Leader>" },
          { mode = { "n", "x" }, keys = "g" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = { "i", "c" }, keys = "<C-x>" },
          { mode = { "n", "x" }, keys = "'" },
          { mode = { "n", "x" }, keys = "`" },
          { mode = { "n", "x" }, keys = '"' },
          { mode = "n", keys = "<C-w>" },
          { mode = { "n", "x" }, keys = "z" },
        },
        clues = {
          miniclue.gen_clues.square_brackets(),
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          config = { border = "rounded" },
          delay = 100,
        },
      })
      vim.api.nvim_set_hl(0, "MiniClueBorder", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueDescGroup", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueDescSingle", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueNextKey", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueNextKeyWithPostkeys", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueSeparator", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniClueTitle", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", ctermbg = "NONE" })
      vim.schedule(function()
        miniclue.ensure_all_triggers()
      end)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "bash",
          "c",
          "cpp",
          "rust",
          "python",
          "javascript",
          "typescript",
          "tsx",
          "json",
          "yaml",
          "html",
          "css",
          "markdown",
          "markdown_inline",
          "go",
          "toml",
          "cmake",
          "dockerfile",
          "sql",
        },
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = false,
        },
      })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      -- rust-tools will be configured from lua/custom/lsp.lua
    end,
  },

  -- {
  --   "dart-lang/dart-vim-plugin",
  --   ft = { "dart" },
  -- },
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          on_attach = require("custom.lsp").on_attach,
          capabilities = require("custom.lsp").capabilities,
        },
        ui = {
          border = "rounded",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("custom.lsp")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
    },
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    config = function()
      require("ibl").setup({
        scope = {
          char = "│",
          show_start = true,
          show_end = true,
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { hl = 'GitGutterAdd', text = '│', numhl='GitSignsAddNr', linehl='GitSignsAddLn' },
          change = { hl = 'GitGutterChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
          delete = { hl = 'GitGutterDelete', text = '▾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
          topdelete = { hl = 'GitGutterDelete', text = '▾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
          changedelete = { hl = 'GitGutterChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl = false,
        linehl = false,
        preview_config = { border = 'single' },
        watch_index = { interval = 1000 },
        current_line_blame = false,
        word_diff = false,
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>n", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
      { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          indent = { padding = 0 },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
          },
        },
        window = {
          position = "left",
          width = 40,
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
          },
        },
        filesystem = {
          follow_current_file = true,
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
      })
    end,
  },
})
