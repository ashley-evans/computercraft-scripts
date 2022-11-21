package.path = package.path .. ";" .. debug.getinfo(1).short_src:match("(.-)[^\\/]+$") .. "?.lua;"

local tableUtils = require("table-utils")

describe("helpers", function ()
    it("table Contains works as expected", function ()
        assert.is_true(tableUtils.tableContains({"test", "foo", "bar"}, "test"))
        assert.is_false(tableUtils.tableContains({"test", "foo", "bar"}, "baz"))
        assert.is_true(tableUtils.tableContains({"test", "foo", "bar"}, "bar"))
    end)

    it("table length works as expected", function ()
        assert.equal(tableUtils.tableLength({"test"}), 1)
        assert.equal(tableUtils.tableLength({"test", {}, "bar"}), 3)
    end)

    it("print table works", function ()
        local table = {
            {hi = "foo"}
        }
        local actual = tableUtils.tableToString(table)
        assert.equal('{"1": {"hi": "foo"}}', actual)
    end)

    it("print table works", function ()
        local table = {hi = "foo"}

        local actual = tableUtils.tableToString(table)
        assert.equal('{"hi": "foo"}', actual)
    end)

    it("print table nested", function ()
        local table = {
            wibble = {
                wobble = {
                    wibble = {
                        wobble = {
                            poo = "pee"
                        }
                    }
                }
            }
        }

        local actual = tableUtils.tableToString(table)
        assert.equal( '{"wibble": {"wobble": {"wibble": {"wobble": {"poo": "pee"}}}}}', actual)
    end)
    it("print table stops at 5th level nesting", function ()
        local table = {
            wibble = {
                wobble = {
                    wibble = {
                        wobble = {
                            fifthLevel = {
                                thisShouldBeTooDeep = true
                            }
                        }
                    }
                }
            }
        }
        local actual = tableUtils.tableToString(table)
        assert.equal( '{"wibble": {"wobble": {"wibble": {"wobble": {"fifthLevel": "<table>"}}}}}', actual)
    end)

    it("deals with empty tables correctly", function ()
        local table = {
            wibble = {
                wobble = {},
            }
        }
        local actual = tableUtils.tableToString(table)
        assert.equal( '{"wibble": {"wobble": {}}}', actual)
    end)
end)
