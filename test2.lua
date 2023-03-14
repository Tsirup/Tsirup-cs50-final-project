function InTable(table, value)
    for i, v in ipairs(table) do
      if v == value then
        return true
      end
    end
    return false
end
function TableHasKey(table,key)
    return table[key] ~= nil
end

function Unconcatenate(str, delimiter)
  local function isNumeric(substr)
    return tonumber(substr) ~= nil
  end
  local substrings = {}
  for substring in str:gmatch("[^" .. delimiter .. "]+") do
      if isNumeric(substring) then
        table.insert(substrings, tonumber(substring))
      else
        table.insert(substrings, substring)
      end
  end
  return substrings
end

-- example usage
local concatenated = "3, 5"
local unconcatenated = Unconcatenate(concatenated, ", ")
print(unconcatenated)