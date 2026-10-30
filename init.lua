vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("custom.options")
require("configs.editor")
require("custom.plugins")
require("custom.theme").setup()
require("custom.lsp")
require("plugins.flutter")
