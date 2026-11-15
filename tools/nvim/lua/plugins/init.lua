return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = { rust = { "rustfmt" }, lua = { "stylua" } },
      format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      -- rustaceanvim owns the Rust client.
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          default_settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              cargo = { buildScripts = { enable = true } },
              procMacro = { enable = true },
            },
          },
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup {}
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "toml", "lua", "vim", "help" },
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "codelldb", "stylua", "tree-sitter-cli" } },
  },
}
