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

ta = {}
e = {2,12}
ta[e] = 3
print(TableHasKey(ta,{2,12}))
print(e == {2,12})

local foo = {1,2,3}
print(foo == {1,2,3})
print(table.concat(foo))
print(foo)