-- the most mathmatically intensive and overall challenging part of this project
-- this was extremely headache-inducing but i learned a lot about pathfinding alogrithms
function Movement(unit)
    local validTiles = FindPaths(unit)
    for _, element in ipairs(validTiles) do
        print(element)
    end
end

function FindPaths(unit)
    local start = {unit.y, unit.x}
    local frontier = PriorityQueue:new()
    frontier:push(table.concat(start,", "),0)
    local cameFrom = {}
    local costSoFar = {}
    cameFrom[table.concat(start,", ")] = nil
    costSoFar[table.concat(start,", ")] = 0
    while #frontier > 0 do
        local current = frontier:pop()
        for _, neighbor in Adjacent(current[1], current[2]) do
            local newCost = costSoFar[table.concat(current,", ")] + Movecost[unit.moveType][Tilemap[neighbor[1]][neighbor[2]]]
            if (not KeyInTable(costSoFar, neighbor) or newCost < costSoFar[table.concat(neighbor,", ")]) and newCost <= unit.move then
                costSoFar[table.concat(neighbor,", ")] = newCost
                local priority = newCost
                frontier:push(table.concat(neighbor,", ", priority))
                cameFrom[table.concat(neighbor,", ")] = current
            end
        end
    end
    -- change if needed
    return cameFrom
end

-- remove if not used
function Reverse(inputTable)
    local reversed = {}
    for i = #inputTable, 1, -1 do
        table.insert(reversed, inputTable[i])
    end
    return reversed
end

-- even though I already have the function Neighbors(i,j)
-- I needed another one to give me just the relevant adjacent tile indexes
-- rather than the full adjacent matrix
function Adjacent(i,j)
    local leftedge = false
    local rightedge = false
    local topedge = false
    local botedge = false
    if i == 1 then
        topedge = true
    elseif i == #Tilemap then
        botedge = true
    end
    if j == 1 then
        leftedge = true
    elseif j == #(Tilemap[i]) then
        rightedge = true
    end
    if topedge then
        if leftedge then
            return {{i,j+1},{i+1,j}}
        end
        if rightedge then
            return {{i,j-1},{i+1,j-1}}
        end
        return 
            {{i,j-1},{i,j+1},{i+1,j}}
    end
    if botedge then
        if leftedge then
            return
                {{i-1,j},{i,j+1}}
        end
        if rightedge then
            return {{i-1,j},{i,j-1}}
        end
        return {{i-1,j},{i,j-1},{i,j+1}}
    end
    if leftedge then
        return {{i-1,j},{i,j+1},{i+1,j}}
    end
    if rightedge then
        return {{i-1,j},{i,j-1},{i+1,j}}
    end
    return {{i-1,j},{i,j-1},{i,j+1},{i+1,j}}
end

-- units have different movement costs through different terrain
-- "impossible" movement such as land units through seas are set to 99 move, a number that will never be reached in gameplay
Movecost = {}
Movecost["ship"] =      {01,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,02,99,99,99,99,99}
Movecost["transport"] = {01,99,99,99,99,99,99,99,99,99,99,99,99,99,99,01,99,99,99,99,02,99,99,99,99,99}
Movecost["air"] =       {01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01}
Movecost["infantry"] =  {99,01,01,01,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01}
Movecost["mech"] =      {99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01}
Movecost["tire"] =      {99,02,03,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01}
Movecost["tread"] =     {00,01,02,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01}