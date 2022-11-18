local function getWebContent(url)
    local response = http.get(url)
    if response ~= nil then
        return response.readAll()
    end

    return nil
end

local function writeContentToFile(path, content)
    local handler = fs.open(path, "w")
    if handler == nil then
        return false
    end

    handler.write(content)
    handler.close()
    return true
end

local function storeURLContent(url, path)
    local content = getWebContent(url)
    return writeContentToFile(path, content)
end

-- Scripts

local written = storeURLContent(
    "https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/dig.lua",
    "./dig.lua"
)
if not written then
    print("An error occurred obtaining dig.lua from GitHub")
    return false
end

-- Helpers

written = storeURLContent(
    "https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/logger.lua",
    "./logger.lua"
)
if not written then
    print("An error occurred obtaining logger.lua from GitHub")
    return false
end

written = storeURLContent(
    "https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/turtle-port.lua",
    "./turtle-port.lua"
)
if not written then
    print("An error occurred obtaining turtle-port.lua from GitHub")
    return false
end

written = storeURLContent(
    "https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/table-utils.lua",
    "./table-utils.lua"
)
if not written then
    print("An error occurred obtaining table-utils.lua from GitHub")
    return false
end

written = storeURLContent(
    "https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/turtle-utils.lua",
    "./turtle-utils.lua"
)
if not written then
    print("An error occurred obtaining turtle-utils.lua from GitHub")
    return false
end

written = storeURLContent(
    "https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/actions.lua",
    "./actions.lua"
)
if not written then
    print("An error occurred obtaining actions.lua from GitHub")
    return false
end

written = storeURLContent(
    "https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/collections.lua",
    "./collections.lua"
)
if not written then
    print("An error occurred obtaining collections.lua from GitHub")
    return false
end
