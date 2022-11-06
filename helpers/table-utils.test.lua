package.path = package.path .. (";" .. arg[0]:match("(.-)[^\\/]+$") .. "?.lua;")

require("luarocks.loader")
luaunit = require("luaunit")

tableUtils = require("table-utils")

function testReturnsTrueIfTableContainsProvidedValue()
    local expectedValue = "test"
    local table = { expectedValue }

    actual = tableUtils.tableContains(table, expectedValue)

    luaunit.assertTrue(actual)
end

os.exit( luaunit.LuaUnit.run() )
