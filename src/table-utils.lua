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

local function stringify(table, depth)
    if depth > 5 then
        return "\"<table>\""
    end
    local s = ""
    s = s.."{"
    for k, v in pairs(table) do
        s = s.."\""..k.."\""..": "
        local type = type(v)
        if type == "table" then
            s = s..stringify(v, depth+1)
        else
            s = s.."\""..tostring(v).."\""
        end
        s=s..","
    end
    s = s:sub(1, -2)
    s = s.."}"
    return s
end

local function tableToString(table)
    assert(type(table) == "table", "can only convert table to a string")
    return stringify(table, 1)
end


return {
    tableContains = tableContains,
    tableLength = tableLength,
    tableToString = tableToString,
}

-- local a = {
--     callback = function: 0x130e54880,
--     called = function: 0x130e54c90,
--     revert = function: 0x130e54c50,
--     target_key = run,
--     target_table = {
--         run = {
--             callback = function: 0x130e54880,
--             called = function: 0x130e54c90,
--             revert = function: 0x130e54c50,
--             target_key = run,
--             target_table = {
--                 run = {
--                     callback = function: 0x130e54880,
--                     called = function: 0x130e54c90,
--                     revert = function: 0x130e54c50,
--                     target_key = run,
--                     target_table = <table>,
--                     returned_with = function: 0x130e54ce0,
--                     called_with = function: 0x130e54cb0,
--                     returnvals = <table>,
--                     clear = function: 0x130e54c70,
--                     calls = <table>,
--                 }
--                 args = wibble
--             }
--             returned_with = function: 0x130e54ce0,
--             called_with = function: 0x130e54cb0,
--             returnvals = {
--                 1 = {
--                     refs = <table>,
--                     vals = <table>,
--                 }
--                 2 = {
--                     refs = <table>,
--                     vals = <table>,
--                 }
--             }
--             clear = function: 0x130e54c70,
--             calls = {
--                 1 = {
--                     refs = <table>,
--                     vals = <table>
--                 }
--                 2 = {
--                     refs = <table>,
--                     vals = <table>,
--                 }
--             }
--         }
--         args = wibble
--     }
--     returned_with = function: 0x130e54ce0,
--     called_with = function: 0x130e54cb0,
--     returnvals = {
--         1 = {
--             refs = {n = 0},
--             vals = {n = 0},
--         }
--         2 = {
--             refs = {n = 0},
--             vals = {n = 0},
--         }
--     }
--     clear = function: 0x130e54c70,
--     calls = {
--         1 = {
--             refs = {n = 0},
--             vals = {n = 0},
--         }
--         2 = {
--             refs = {n = 0},
--             vals = {n = 0},
--         }
--     }
-- }
