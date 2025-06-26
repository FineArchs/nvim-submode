-- plugin/submode.lua

vim.api.nvim_create_user_command("SubmodeRestoreOptions", function()
  require("submode").restore_options()
end, { nargs = 0 })

vim.keymap.set("", "<Plug>(submode-before-entering)", function()
  return require("submode.handlers").on_entering(require("submode").current())
end, { expr = true })

vim.keymap.set("", "<Plug>(submode-before-action)", function()
  return require("submode.handlers").on_executing(require("submode").current())
end, { expr = true })

vim.keymap.set("", "<Plug>(submode-leave)", function()
  return require("submode.handlers").on_leaving(require("submode").current())
end, { expr = true })
