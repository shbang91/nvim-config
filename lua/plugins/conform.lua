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
    notify_on_error = false,
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
    },
  },
}
