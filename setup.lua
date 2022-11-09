function getWebContent(url)
    local response = http.get(url)
    if response ~= nil then
        return response.readAll()
    end

    return nil
end

function writeContentToFile(path, content)
    local handler = fs.open(path, "w")
    if handler == nil then
        return false
    end

    handler.write(content)
    handler.close()
    return true
end

function storeURLContent(url, path)
    local content = getWebContent(url)
    return writeContentToFile(path, content)
end

-- Functions

local written = storeURLContent("https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/dig.lua", "./dig.lua")
if not written then
    print("An error occurred obtaining dig.lua from GitHub")
    return false
end

-- Helpers

written = storeURLContent("https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/helpers/table-utils.lua", "./helpers/table-utils.lua")
if not written then
    print("An error occurred obtaining helpers/table-utils.lua from GitHub")
    return false
end

written = storeURLContent("https://raw.githubusercontent.com/ashley-evans/computercraft-scripts/master/src/helpers/turtle-utils.lua", "./helpers/turtle-utils.lua")
if not written then
    print("An error occurred obtaining helpers/turtle-utils.lua from GitHub")
    return false
end
