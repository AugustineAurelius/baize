require "nvchad.mappings"
local map = vim.keymap.set
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Debug: breakpoint" })
map("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: continue" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: step over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: step into" })
map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Debug: REPL" })
map("n", "<leader>dq", function() require("dap").terminate() end, { desc = "Debug: stop" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Files: tree" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: code action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: rename" })
