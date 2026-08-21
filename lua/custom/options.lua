vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set

map("n", "<leader>n", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
map("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Open vertical split" })
map("n", "<leader>V", "<cmd>vsplit<CR>", { desc = "Open vertical split" })
map("n", "<leader>w", "<C-w>w", { desc = "Switch window focus" })
map("n", "<leader>t", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<A-Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<A-S-Tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Flutter
map("n", "<leader>rr", "<cmd>FlutterRun<cr>", { desc = "Flutter Run" })
map("n", "<leader>rd", "<cmd>FlutterDebug<cr>", { desc = "Flutter Debug" })
map("n", "<leader>re", "<cmd>FlutterEmulators<cr>", { desc = "Flutter Emulators" })
map("n", "<leader>rv", "<cmd>FlutterDevices<cr>", { desc = "Flutter Devices" })
map("n", "<leader>rl", "<cmd>FlutterReload<cr>", { desc = "Hot Reload" })
map("n", "<leader>rR", "<cmd>FlutterRestart<cr>", { desc = "Hot Restart" })
map("n", "<leader>rq", "<cmd>FlutterQuit<cr>", { desc = "Quit Flutter" })
map("n", "<leader>ro", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter Outline" })
map("n", "<leader>rL", "<cmd>FlutterLogToggle<cr>", { desc = "Flutter Log" })
map("n", "<leader>rc", "<cmd>FlutterLogClear<cr>", { desc = "Clear Flutter Log" })
map("n", "<leader>ra", "<cmd>FlutterAttach<cr>", { desc = "Attach to App" })
map("n", "<leader>rt", "<cmd>FlutterDevTools<cr>", { desc = "Flutter DevTools" })
  
local set = vim.opt

-- Line Numbers & nav
set.number = true
set.relativenumber = false
set.numberwidth = 1            -- Minimal width for line numbers, expands as needed
set.whichwrap:append("l")
set.whichwrap:append("h")
set.showbreak = "↳"
set.guicursor = {
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}

-- Tab & Indentation
local tab_width = 4
set.tabstop = tab_width          -- Number of spaces a tab counts for
set.shiftwidth = tab_width       -- Number of spaces for auto-indent
set.softtabstop = tab_width      -- Number of spaces for a tab key press
set.expandtab = true             -- Convert tabs to spaces
set.smartindent = true           -- Smart auto-indenting
set.autoindent = true

-- Search Behavior
set.ignorecase = true          -- Case-insensitive search
set.smartcase = false           -- Case-sensitive if uppercase used
set.hlsearch = true            -- Highlight search matches
set.incsearch = true           -- Show matches as you type

-- Visual & UI
set.termguicolors = true       -- Enable true colors (24-bit)
set.cursorline = true          -- Highlight current line
set.signcolumn = "yes"         -- Always show sign column (for git/lint icons)
set.scrolloff = 8              -- Keep 8 lines above/below cursor
set.sidescrolloff = 8          -- Keep 8 columns left/right of cursor
set.wrap = false               -- Don't wrap long lines
set.showmode = false           -- Don't show mode in command line (statusline handles it)

-- Clipboard & System
set.clipboard = "unnamedplus"  -- Sync with system clipboard

-- Split Windows
set.splitright = true          -- Vertical split goes to the right
set.splitbelow = true          -- Horizontal split goes below

-- Mouse Support
set.mouse = "a"                -- Enable mouse in all modes

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Enable filetype detection (crucial for knowing which language to highlight)
vim.cmd("filetype plugin indent on")

-- Force indent settings for all filetypes to follow options.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.tabstop = tab_width
    vim.opt_local.shiftwidth = tab_width
    vim.opt_local.softtabstop = tab_width
  end,
})
