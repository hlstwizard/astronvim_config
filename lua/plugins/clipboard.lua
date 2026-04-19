---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = function()
      local function in_remote_session()
        if vim.env.SSH_CLIENT or vim.env.SSH_TTY then return true end

        local wezterm_executable = vim.env.WEZTERM_EXECUTABLE
        if wezterm_executable and wezterm_executable:find("wezterm-mux-server", 1, true) then return true end

        return false
      end

      if not in_remote_session() then return end

      local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
      if not ok then return end

      local function paste_from_unnamed()
        return function()
          local content = vim.fn.getreg '"'
          return vim.split(content, "\n")
        end
      end

      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = osc52.copy "+",
          ["*"] = osc52.copy "*",
        },
        paste = {
          ["+"] = paste_from_unnamed(),
          ["*"] = paste_from_unnamed(),
        },
      }

      vim.schedule(function() vim.opt.clipboard:append "unnamedplus" end)
    end,
  },
}
