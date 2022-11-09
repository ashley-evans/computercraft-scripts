# ComputerCraft Scripts

[![Validate](https://github.com/ashley-evans/computercraft-scripts/actions/workflows/ci.yml/badge.svg)](https://github.com/ashley-evans/computercraft-scripts/actions/workflows/ci.yml)

## Requirements

Lua Version: 5.4.4

To run the tests in this project, the [Busted](https://lunarmodules.github.io/busted/#usage) framework should be installed. The easiest way to install this is by using the [LuaRocks](https://github.com/luarocks/luarocks/wiki/Download) package manager.

Once LuaRocks is installed, LuaUnit can be installed by running:
```shell
sudo luarocks install busted
```

Individual test scripts can then be executed by running:
```shell
busted /path/to/_spec.lua
```
> The `--verbose` flag can be added to get more verbose test output

All tests can be executed by running:
```shell
busted .
```
