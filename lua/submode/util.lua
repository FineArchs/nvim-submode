-- lua/submode/util.lua
local M = {}

function M.each_char(str)
  local chars = {}
  for c in str:gmatch(".") do
    table.insert(chars, c)
  end
  return chars
end

function M.has_flag(flags, char)
  return flags:find(char, 1, true) ~= nil
end

function M.filter_flags(flags, valid)
  local result = {}
  for _, c in ipairs(M.each_char(valid)) do
    if M.has_flag(flags, c) then
      table.insert(result, c)
    end
  end
  return table.concat(result, "")
end

function M.split_keys(seq)
  local keys = {}
  for key in seq:gmatch("(<[^<>]+>)|(.)") do
    table.insert(keys, key)
  end
  return keys
end

function M.map_options(opts)
  local opt_map = {
    b = true,
    s = true,
    e = true,
    u = true,
    -- 'r' → handled in keymap mode directly
  }

  local result = {}
  for _, c in ipairs(M.each_char(opts)) do
    if opt_map[c] then
      result[c] = true
    end
  end
  return result
end

return M
