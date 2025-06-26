-- lua/submode/handlers.lua

local state = require("submode.state")

local M = {}

function M.on_entering(submode)
  state.set_up_options(submode)
  return ""
end

function M.on_executing(submode)
  if (state.original_options.showmode or state.config.always_show)
    and M._should_override_showmode()
  then
    vim.api.nvim_echo({ { "-- Submode: " .. submode .. " --", "ModeMsg" } }, false, {})
  end
  return ""
end

function M.on_leaving(submode)
  if (state.original_options.showmode or state.config.always_show)
    and M._should_override_showmode()
  then
    local pos
    if M._is_insert_mode() then
      pos = vim.fn.getpos(".")
    end

    -- force redraw
    vim.cmd("redraw!")

    if pos then
      vim.fn.setpos(".", pos)
    end
  end

  if not state.config.keep_leaving_key and vim.fn.getchar(1) ~= 0 then
    vim.fn.getchar()  -- discard key
  end

  state.restore_options()
  return ""
end

-- internal helpers

function M._is_insert_mode()
  local m = vim.fn.mode()
  return m == "i" or m == "R"
end

function M._should_override_showmode()
  local m = vim.fn.mode()
  return m:match("^[nvV\<C-v>sS\<C-s>]") or M._is_insert_mode()
end

return M
