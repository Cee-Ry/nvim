local M = {}

M.default_theme = "catppuccin"

local is_restoring = false
local initialized = false

-- Candidate file paths for storing the theme name.
-- 1. Neovim state directory (~/.local/state/nvim/current_theme.txt) - XDG standard for state
-- 2. Neovim data directory (~/.local/share/nvim/current_theme.txt) - fallback
-- 3. Neovim config directory (~/.config/nvim/.current_theme) - fallback
local function get_theme_files()
  return {
    vim.fn.stdpath("state") .. "/current_theme.txt",
    vim.fn.stdpath("data") .. "/current_theme.txt",
    vim.fn.stdpath("config") .. "/.current_theme",
  }
end

-- Read the persisted theme name from disk
function M.get_saved_theme()
  for _, filepath in ipairs(get_theme_files()) do
    local f = io.open(filepath, "r")
    if f then
      local content = f:read("*a")
      f:close()
      if content then
        local theme = vim.trim(content)
        if theme ~= "" then
          return theme
        end
      end
    end
  end
  return nil
end

-- Write the theme name to disk
function M.save_theme(theme)
  if not theme or theme == "" then
    return false
  end

  for _, filepath in ipairs(get_theme_files()) do
    local dir = vim.fn.fnamemodify(filepath, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      pcall(vim.fn.mkdir, dir, "p")
    end

    local f = io.open(filepath, "w")
    if f then
      f:write(theme .. "\n")
      f:close()
      return true
    end
  end

  return false
end

-- Safely apply a colorscheme with fallback
function M.apply_theme(theme)
  theme = theme or M.get_saved_theme() or M.default_theme

  is_restoring = true
  local ok = pcall(vim.cmd.colorscheme, theme)

  if not ok then
    -- Try loading the plugin via lazy in case it was lazy-loaded
    local has_lazy, lazy = pcall(require, "lazy")
    if has_lazy then
      pcall(lazy.load, { plugins = { theme, theme .. ".nvim" } })
      ok = pcall(vim.cmd.colorscheme, theme)
    end
  end

  if not ok then
    -- Fallback to default theme (catppuccin)
    if theme ~= M.default_theme then
      local fallback_ok = pcall(vim.cmd.colorscheme, M.default_theme)
      if not fallback_ok then
        pcall(vim.cmd.colorscheme, "default")
      end
    else
      pcall(vim.cmd.colorscheme, "default")
    end
  end

  is_restoring = false
  return ok
end

function M.setup()
  if initialized then
    return
  end
  initialized = true

  -- Load the saved theme or default to catppuccin
  local saved_theme = M.get_saved_theme()
  local initial_theme = saved_theme or M.default_theme

  M.apply_theme(initial_theme)

  -- Persist default if no theme was previously saved
  if not saved_theme then
    M.save_theme(initial_theme)
  end

  -- Listen for theme changes made by the user
  local group = vim.api.nvim_create_augroup("PersistentTheme", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function(args)
      if is_restoring then
        return
      end
      local theme = (args.match and args.match ~= "") and args.match or vim.g.colors_name
      if theme and theme ~= "" then
        M.save_theme(theme)
      end
    end,
  })

  -- Helper command: :Theme [name] to view or switch themes
  vim.api.nvim_create_user_command("Theme", function(opts)
    if opts.args == "" then
      local current = vim.g.colors_name or M.get_saved_theme() or "default"
      vim.notify("Current theme: " .. current, vim.log.levels.INFO)
    else
      vim.cmd.colorscheme(opts.args)
    end
  end, {
    nargs = "?",
    complete = "color",
    desc = "View or switch colorscheme (persisted across sessions)",
  })
end

return M
