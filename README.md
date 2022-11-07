# ComputerCraft Scripts

## Requirements

Lua Version: 5.4.4

To run the tests in this project, the [LuaUnit](https://luaunit.readthedocs.io/en/latest/#installation) framework should be installed. The easiest way to install this is by using the [LuaRocks](https://github.com/luarocks/luarocks/wiki/Download) package manager.

Once LuaRocks is installed, LuaUnit can be installed by running:
```shell
sudo luarocks install luaunit
```

Individual test scripts can then be executed by running:
```shell
lua insert_test_name_here.lua
```
> The `--verbose` flag can be added to get more verbose test output

All tests can be executed by running:
```shell
xargs -r0a <(find . -name *.test.lua -print0) -I {} sh -c 'echo "\nRunning tests in: {}\n"; lua {} --verbose'
```
