return {
  "milanglacier/minuet-ai.nvim",
  config = function()
    require("minuet").setup {
      cmp = {
        enable_auto_complete = false,
      },
      blink = {
        enable_auto_complete = false,
      },
      virtualtext = {
        auto_trigger_ft = { "python", "lua", "c", "cpp", "markdown" },
        keymap = {
          accept = "<A-a>",
          accept_line = "<A-A>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
      provider = "gemini",
      provider_options = {
        gemini = {
          model = "gemini-2.0-flash",
          system = "see [Prompt] section for the default value",
          few_shots = "see [Prompt] section for the default value",
          chat_input = "See [Prompt Section for default value]",
          stream = true,
          api_key = "AIzaSyAmyWtaPeHae5LGtEeRnrZyA_RxmyACKro",
          end_point = "https://generativelanguage.googleapis.com/v1beta/models",
          optional = {
            generationConfig = {
              maxOutputTokens = 256,
              -- When using `gemini-2.5-flash`, it is recommended to entirely
              -- disable thinking for faster completion retrieval.
              thinkingConfig = {
                thinkingBudget = 0,
              },
            },
            safetySettings = {
              {
                -- HARM_CATEGORY_HATE_SPEECH,
                -- HARM_CATEGORY_HARASSMENT
                -- HARM_CATEGORY_SEXUALLY_EXPLICIT
                category = "HARM_CATEGORY_DANGEROUS_CONTENT",
                -- BLOCK_NONE
                threshold = "BLOCK_ONLY_HIGH",
              },
            },
          },
        },
      },
    }
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
}
