local function tableContains(table, val)
    assert(type(table) == "table", "expected a table but got " .. type(table))
    for _, v in ipairs(table) do
        if  v == val then
            return true
        end
    end
    return false
end

local function tableLength(table)
    assert(type(table) == "table", "can only count tableLength of a table")
    local count = 0
    for _ in pairs(table) do
         count = count + 1 
    end
    return count
end
return {
    tableContains = tableContains,
    tableLength = tableLength
}
