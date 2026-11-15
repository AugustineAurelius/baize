require("lazy").load { plugins = { "mason.nvim", "nvim-treesitter" } }
local registry = require "mason-registry"
local finished, failure = false, nil
registry.refresh(function(ok)
  if not ok then
    failure = "Cannot refresh Mason registry"
    finished = true
    return
  end
  local remaining = 3
  for _, name in ipairs { "codelldb", "stylua", "tree-sitter-cli" } do
    local package = registry.get_package(name)
    local function complete(success)
      if not success then failure = "Mason installation failed: " .. name end
      remaining = remaining - 1
      finished = remaining == 0
    end
    if package:is_installed() then
      complete(true)
    else
      package:install():once("closed", vim.schedule_wrap(function()
        complete(package:is_installed())
      end))
    end
  end
end)
assert(vim.wait(300000, function() return finished end, 100), "Mason installation timed out")
assert(not failure, failure)
require("nvim-treesitter").install({ "rust", "toml", "lua", "vim", "vimdoc" }):wait(300000)
print "Rust tools and parsers installed"
