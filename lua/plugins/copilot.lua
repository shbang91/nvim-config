return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      -- You can disable auto-trigger if you find it too distracting
      auto_trigger = true,
      -- Keymaps for interacting with suggestions
      keymap = {
        accept = "<C-l>", -- Accept the suggestion
        next = "<C-j>", -- Cycle to the next suggestion
        prev = "<C-k>", -- Cycle to the previous suggestion
        dismiss = "<C-h>", -- Dismiss the current suggestion
      },
    },
    panel = {
      -- Enable the panel to see multiple suggestions
      enabled = true,
    },
    filetypes = {
      -- Add any filetypes you want to disable Copilot for
      -- For example, to disable it for markdown files:
      -- markdown = false,
      help = false,
    },
  },
}
