local function tableContains(table, val)
    for i, v in ipairs(table) do
        if  v == val then
            return true
        end
    end
    return false
end

return {
    tableContains = tableContains
}
