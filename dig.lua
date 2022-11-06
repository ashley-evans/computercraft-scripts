-- digs a 2x1 tunnel 
-- auto refuels
-- keeps track of how much fuel total it has in in inv to determine its "point of no return" and then comes back to start point
-- avoids actually digging anything useful? (e.g. diamonds)
-- for now pauses at this point
    -- later works around the deposit and carries on digging the tunnel

function tableContains(table, val)
    for i, v in ipairs(table) do
        if  v == val then
            return true
        end
    end
    return false
end

function blockIsResource(blockToCheck)
    local resourceBlocks = {"minecraft:diorite"}
    return tableContains(resourceBlocks, blockToCheck)
end

function digIfSafe() 
    local hasBlock, data = turtle.inspect()
    if blockIsResource(data.name) then
        return false
    else
        turtle.dig()
        return true
    end
end

function digUpIfSafe()
    local hasBlock, data = turtle.inspectUp()
    if blockIsResource(data.name) then
        return false
    else
        turtle.digUp()
        return true
    end
end

function dig()
    local count = 0
    while true do
        if count > 10 then
            break
        end
        if turtle.getFuelLevel() < 2 then
            turtle.refuel()
        end


        local dug = digIfSafe()
        if not dug then
            print("dig not safe")
            return
        end

        dug = digUpIfSafe()
        if not dug then
            print("dig up not safe")
            return
        end

        count = count + 1
    end
end

dig()
