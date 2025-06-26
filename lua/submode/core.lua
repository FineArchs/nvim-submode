-- lua/submode/core.lua

local util = require("submode.util")
local state = require("submode.state")

local M = {}

-- internal helpers
local function make_lhs(submode, prefix)
  return string.format("<Plug>(submode-%s:%s)", prefix, submode)
end

local function make_rhs(submode, lhs)
  return string.format("<Plug>(submode-rhs:%s:for:%s)", submode, lhs)
end

local function make_prefix(submode)
  return string.format("<Plug>(submode-prefix:%s)", submode)
end

local function make_enter(submode)
  return string.format("<Plug>(submode-enter:%s)", submode)
end

local function make_leave(submode)
  return string.format("<Plug>(submode-leave:%s)", submode)
end

-- public API

function M.enter_with(submode, modes, opts, lhs, rhs)
  rhs = rhs or "<Nop>"
  for _, mode in ipairs(util.each_char(modes)) do
    -- Define trigger mapping (enter submode)
    vim.keymap.set(mode, lhs, function()
      state.set_up_options(submode)
      return make_enter(submode)
    end, { expr = true })

    -- Define <Plug>(submode-enter:...)
    vim.keymap.set(mode, make_enter(submode), function()
      -- map prefix + keys in map()
      return make_prefix(submode)
    end, { expr = true })

    -- Map the key used to enter to the actual command
    vim.keymap.set(mode, string.format("<Plug>(submode-before-entering:%s:with:%s)", submode, lhs), rhs, util.map_options(opts))

    -- Leave keys (e.g. <Esc>)
    for _, keyseq in ipairs(state.config.keyseqs_to_leave) do
      M.leave_with(submode, mode, opts, keyseq)
    end
  end
end

function M.leave_with(submode, modes, opts, lhs)
  opts = opts:gsub("e", "") .. "x"  -- Remove <expr>, add "exit"
  M.map(submode, modes, opts, lhs, "<Nop>")
end

function M.map(submode, modes, opts, lhs, rhs)
  for _, mode in ipairs(util.each_char(modes)) do
    local full_lhs = make_prefix(submode) .. lhs
    local final_rhs = make_rhs(submode, lhs) .. (opts:find("x") and make_leave(submode) or make_enter(submode))

    -- Internal prefix mapping (e.g. <Plug>(submode-prefix:foo)h)
    vim.keymap.set(mode, full_lhs, final_rhs, util.map_options(opts))

    -- Actual command mapping
    vim.keymap.set(mode, make_rhs(submode, lhs), rhs, util.map_options(opts))

    -- Map shorter prefixes to allow early leave
    local keys = util.split_keys(lhs)
    for n = 1, #keys - 1 do
      local partial = table.concat(keys, "", 1, n)
      vim.keymap.set(mode, make_prefix(submode) .. partial, make_leave(submode), util.map_options(opts))
    end
  end
end

function M.unmap(submode, modes, opts, lhs)
  for _, mode in ipairs(util.each_char(modes)) do
    vim.keymap.del(mode, make_rhs(submode, lhs), util.map_options(opts))

    local keys = util.split_keys(lhs)
    for n = #keys, 1, -1 do
      local partial = table.concat(keys, "", 1, n)
      local target = make_prefix(submode) .. partial
      pcall(vim.keymap.del, mode, target, util.map_options(opts))
    end
  end
end

return M
