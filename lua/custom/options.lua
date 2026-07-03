vim.g.mapleader = " "
vim.g.maplocalleader = " "
  
local set = vim.opt

-- Line Numbers 
set.number = true
set.relativenumber = false

-- Tab & Indentation
set.tabstop = 4                -- Number of spaces a tab counts for
set.shiftwidth = 4             -- Number of spaces for auto-indent
set.softtabstop = 4            -- Number of spaces for a tab key press
set.expandtab = true           -- Convert tabs to spaces
set.smartindent = true         -- Smart auto-indenting
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
