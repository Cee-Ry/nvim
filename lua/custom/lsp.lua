local cmp = require("cmp")
local luasnip = require("luasnip")

local M = {}

vim.filetype.add({
  extension = {
    h = "c",
    hh = "cpp",
    hpp = "cpp",
    cc = "cpp",
    cxx = "cpp",
    ts = "typescript",
    tsx = "typescriptreact",
    js = "javascript",
    jsx = "javascriptreact",
    mdx = "markdown",
  },
})

-- Autocomplete setup
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- LSP on_attach callback
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Keymaps for LSP
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
end

-- Export helpers so other modules / plugins can reuse them
M.on_attach = on_attach

local capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities = capabilities

-- Enhanced capabilities for better completion
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

local server_configs = {
  {
    name = "lua_ls",
    filetypes = { "lua" },
    cmd = { "lua-language-server" },
  },
  {
    name = "clangd",
    filetypes = { "c", "cpp", "objc", "objcpp" },
    cmd = { "clangd", "--background-index", "--clang-tidy" },
  },
  {
    name = "bashls",
    filetypes = { "bash", "sh", "zsh" },
    cmd = { "bash-language-server" },
  },
  {
    name = "rust_analyzer",
    filetypes = { "rust" },
    cmd = function()
      local ra_path = vim.fn.exepath("rust-analyzer")
      if ra_path ~= "" then
        return { ra_path }
      end
      return { "/usr/bin/rust-analyzer" }
    end,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = true,
      },
    },
  },
  {
    name = "pyright",
    filetypes = { "python" },
    cmd = { "pyright-langserver", "--stdio" },
  },
  {
    name = "ts_ls",
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "jsx", "tsx" },
    cmd = { "typescript-language-server", "--stdio" },
  },
  {
    name = "gopls",
    filetypes = { "go" },
    cmd = { "gopls" },
  },
  {
    name = "html",
    filetypes = { "html" },
    cmd = { "vscode-html-language-server", "--stdio" },
  },
  {
    name = "cssls",
    filetypes = { "css", "scss", "less" },
    cmd = { "vscode-css-language-server", "--stdio" },
  },
  {
    name = "jsonls",
    filetypes = { "json" },
    cmd = { "vscode-json-language-server", "--stdio" },
  },
  {
    name = "yamlls",
    filetypes = { "yaml", "yml" },
    cmd = { "yaml-language-server", "--stdio" },
  },
  {
    name = "marksman",
    filetypes = { "markdown", "markdown.mdx" },
    cmd = { "marksman" },
  },
  {
    name = "cmake",
    filetypes = { "cmake" },
    cmd = { "cmake-language-server" },
  },
}

local enabled_servers = {}
for _, server in ipairs(server_configs) do
  local cmd = server.cmd
  if type(cmd) == "function" then
    cmd = cmd()
  end

  local executable = nil
  if type(cmd) == "table" and #cmd > 0 then
    executable = cmd[1]
  end

  if executable ~= nil and (vim.fn.exepath(executable) ~= "" or vim.fn.executable(executable) == 1) then
    local config = {
      cmd = cmd,
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = server.filetypes,
    }

    if server.settings then
      config.settings = server.settings
    end

    vim.lsp.config(server.name, config)
    table.insert(enabled_servers, server.name)
  end
end

vim.lsp.enable(enabled_servers)

return M
