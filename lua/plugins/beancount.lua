-- Beancount support, ported from kickstart.nvim custom/ folder.
-- - Installs the `beancount` treesitter parser
-- - Warns when `bean-format` is missing (used by conform.nvim for formatting)

local warned_missing_bean_format = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "beancount",
  group = vim.api.nvim_create_augroup("beancount-format-check", { clear = true }),
  callback = function()
    if warned_missing_bean_format or vim.fn.executable "bean-format" == 1 then return end
    warned_missing_bean_format = true
    vim.notify(
      "bean-format not found. Install it with: uv tool install beancount",
      vim.log.levels.WARN,
      { title = "conform.nvim" }
    )
  end,
})

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      treesitter = {
        ensure_installed = { "beancount" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        beancount = { "bean-format" },
      },
    },
  },
}
