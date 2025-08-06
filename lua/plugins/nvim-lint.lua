return {
  "mfussenegger/nvim-lint",
  keys = {
    {
      "<leader>la", -- "Lint All"
      function()
        -- Runs all linters defined in 'linters_by_ft' for the file type
        require("lint").try_lint()
      end,
      mode = "",
      desc = "[L]int All (flake8 + black)",
    },
    {
      "<leader>lf", -- "Lint Flake8"
      function()
        -- Runs only the specified linter
        require("lint").try_lint "flake8"
      end,
      mode = "",
      desc = "[L]int with Flake8",
    },
    {
      "<leader>lb", -- "Lint Black"
      function()
        -- Runs only the specified linter
        require("lint").try_lint "black"
      end,
      mode = "",
      desc = "[L]int with Black",
    },
  },
  config = function()
    local lint = require "lint"

    -- Configure linters by file type. This is the default for '<leader>la'
    lint.linters_by_ft = {
      python = { "flake8", "black" },
      cpp = { "clangtidy" },
      c = { "clangtidy" },
    }

    -- Define the linter configurations
    lint.linters = {
      flake8 = {
        name = "flake8",
        cmd = "flake8",
        args = {
          "--config",
          vim.fn.expand "~/catkin_ws/src/apptronik_core/.flake8",
          "--stdin-display-name",
          "%:p",
          "-",
        },
        stdin = true,
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          local pattern = "([^:]+):(%d+):(%d+): (%w%d+) (.+)"
          for line in vim.gsplit(output, "\n") do
            local filename, row, col, code, message = line:match(pattern)
            if filename and row and col and code and message then
              table.insert(diagnostics, {
                lnum = tonumber(row) - 1,
                col = tonumber(col) - 1,
                message = string.format("[%s] %s", code, message),
                severity = vim.diagnostic.severity.WARN,
                source = "flake8",
              })
            end
          end
          return diagnostics
        end,
      },

      black = {
        name = "black",
        cmd = "black",
        args = {
          "--check", -- Run in checking mode, don't modify files
          "--quiet", -- Suppress non-error output
          "-", -- Read from stdin
        },
        stdin = true,
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          if string.find(output, "would reformat", 1, true) then
            table.insert(diagnostics, {
              lnum = 0, -- File-level diagnostic on the first line
              col = 0,
              message = "File needs reformatting (black --check).",
              severity = vim.diagnostic.severity.WARN,
              source = "black",
            })
          end
          return diagnostics
        end,
      },

      clangtidy = {
        name = "clangtidy",
        cmd = "clang-tidy",
        args = { "$FILENAME", "--quiet" },
        stdin = false,
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          local pattern = "([^:]+):(%d+):(%d+): (%w+): (.+) %[([^%]]+)%]"
          for line in vim.gsplit(output, "\n") do
            local filename, row, col, sev_str, message, check = line:match(pattern)
            if filename and row and col and sev_str and message and check then
              local severity = vim.diagnostic.severity.INFO
              if sev_str == "warning" then
                severity = vim.diagnostic.severity.WARN
              elseif sev_str == "error" then
                severity = vim.diagnostic.severity.ERROR
              elseif sev_str == "note" then
                severity = vim.diagnostic.severity.INFO
              end
              table.insert(diagnostics, {
                lnum = tonumber(row) - 1,
                col = tonumber(col) - 1,
                message = string.format("[%s] %s", check, message),
                severity = severity,
                source = "clang-tidy",
              })
            end
          end
          return diagnostics
        end,
      },
    }
  end,
}
