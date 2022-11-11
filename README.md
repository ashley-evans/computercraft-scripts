# ComputerCraft Scripts

[![Validate](https://github.com/ashley-evans/computercraft-scripts/actions/workflows/ci.yml/badge.svg)](https://github.com/ashley-evans/computercraft-scripts/actions/workflows/ci.yml)

## Requirements

- Lua Version: 5.4.4
- LuaRocks package manager: [Installation Guide](https://github.com/luarocks/luarocks/wiki/Download)

## Testing

To run the tests in this project, the [Busted](https://lunarmodules.github.io/busted/#usage) framework should be installed. Busted can be installed by running:

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

## Linting

To run the linter on the files in this project, the [LuaCheck](https://luacheck.readthedocs.io/en/stable/index.html) linter should be installed. LuaCheck can be installed by running:

```shell
sudo luarocks install luacheck
```

Individual tests scripts can be linted by running:

```shell
luacheck /path/to/file.lua
```

All files can be linted by running:

```shell
luacheck .
```

## Setup on Turtle

All of the scripts in this repository can be installed on a turtle by running the following commands on the turtle itself:

```shell
wget https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/setup.lua setup
setup
```
