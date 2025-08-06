return {
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local disable_filetypes = {}
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      cpp = { "uncrustify" },
      c = { "uncrustify" },
      lua = { "stylua" },
      -- Run black first, as it's the more comprehensive formatter.
      -- flake8 was removed as it is a linter, not a formatter.
      python = { "black" },
      -- python = { "black", "autopep8" },
    },
    formatters = {
      uncrustify = {
        command = "uncrustify",
        args = {
          "-c",
          vim.fn.expand "~/catkin_ws/src/apptronik_core/uncrustify.cfg",
          "--replace",
          "--no-backup",
          "$FILENAME",
        },
        stdin = false,
      },
      autopep8 = {
        command = "autopep8",
        args = {
          "--aggressive",
          "--aggressive",
          "-",
        },
        stdin = true,
      },
      -- Added the black formatter configuration
      black = {
        command = "black",
        args = { "-" },
        stdin = true,
      },
    },
  },
}
