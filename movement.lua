-- one of the the most mathmatically intensive and overall challenging parts of this project
-- this was extremely headache-inducing but i learned a lot about pathfinding alogrithms
-- the alogrithm of choice is Breadth-first alogrithm since we need to look at ALL possible tiles to create the selection of valid tiles
-- if we wanted to only consider one "goal" tile, we should instead use A* alogrithm since its faster on giving us the best possible route to that one tile
-- we end up doing this afterwards for more user-friendly visual queues and to properly work around fog and invisible units
-- many older games like Fire Emblem 1 on the NES can't use either of these since they simply overpower the old 8-bit processors
-- that is why that game has no visible grid when you are moving your characters
-- so you are forced to just move the cursor around to discover your range of movement yourself
-- when you move the cursor in that game it is tile-by-tile doing pathfinding based on your d-pad movement which is incredibly optimized and simply awesome and i wish i could figure out how to do it
-- we have modern technology so we don't have to worry about this i guess, at least this Breadth-first + A* configuration that I hodge-podged together looks nice
function Movement(unit)
    local validTiles = FindPaths(unit)
    local highlighted = {}
    for key, value in pairs(validTiles) do
        local highlight = Unconcatenate(key,", ")
        table.insert(highlight,value)
        table.insert(highlighted,highlight)
    end
    -- i want to attach the totalPath to each tile so we can visualize that path in an arrow
    -- this is what makes it a hybrid Breath-first + A* pathfinding algorithm
    -- for optimization we can get rid of the first and last element in totalPath because that is always the start and goal tiles which we already know
    for _, goalTile in ipairs(highlighted) do
        table.insert(goalTile, Astar(unit,{goalTile[1],goalTile[2]}))
    end
    return highlighted
end

function FindPaths(unit)
    -- documented extensively because a lot is going on here and I've already had to refactor this several times
    -- note that i'm still relatively certain there IS an elegant way to do this algorithm that involves recursion but unfortunately it is just to galaxy brain for me
    -- I couldn't manage it

    -- start point, all nodes are classified by {y-coord,x-coord,costSoFar}
    local root = {unit.y, unit.x, 0}
    -- we use a priority queue because we want to go down the easy paths first
    -- when we reach a tile, we only consider the first way we got to that tile, even if there are multiple ways there, otherwise runtime could get crazy
    -- if the first way we get to a tile isn't the fastest, then we have basicly forced ourself to take a slow path and we've failed, potentially messing up all paths leading from that tile
    -- because of this, we want to make sure that the first way there is going to be the fastest, and we can do this by dequeueing tiles in the order of their cost to get there
    -- a priority queue lets us do this!
    -- thank you to a certain legend on discord who brought this to my attention, this is brilliant and im sure i never would have thought of doing this on my own
    -- im pretty sure even with this we could still accidently pick a slow path, but now its certainly much less likely
    local frontier = PriorityQueue:new()
    -- list of all nodes we have already explored
    local explored = {}
    -- jankiness begins
    -- if we were to pass an unconcatenated node as the key in here, lets say, root with values {5,5,0}
    -- we would run into problems later if another node has the same values of a previous node, lets say, current with values {5,5,0}
    -- even though their values are the same, they will not be equivalent since they are in actuallity references to different tables
    -- unlike in a language like C, in Lua, there is no dereference operator to provide an easy solution to this problem
    -- likewise we cannot solve this with fields such as explored.current since it will just get constantly overwritten in the loop
    -- ultimately, the reason we concatenate the variables is that it is just a way to pass in the values of the variables rather than the variables themselves
    -- for all our nodes in explored, we have a 2D coordinate as the key and the cost to get there for the value, we will need the value later for other functions
    explored[table.concat(root, ", ", 1, 2)] = root[3]
    -- our start point is the first element in the queue
    frontier:push(root,root[3])

    -- our maximum range of movement is the lesser out of movement range and fuel. 
    -- if a unit has 1 fuel, we should not care that it has a movement range of 9. then it can only move 1 space
    local moveCap = 0
    if unit.move < unit.fuel then
        moveCap = unit.move
    else
        moveCap = unit.fuel
    end
    -- the function will terminate when we have exhausted the queue
    while frontier.size > 0 do
        -- removing an element every iteration will guarentee we can terminate the while loop
        local current = frontier:pop()
        -- we can only move if we have not moved some amount over than our movement cap
        if current[3] <= moveCap then
            -- for each tile, we only attempt to move into tiles adjacent to a tile we can already be in
            for _, neighbor in ipairs(Adjacent(current[1], current[2])) do
                -- we increment the cost by a value determined by the terrain we are on and what type of unit we are
                -- the + 1 is because the tilemap keys are 0 indexed compared to Movecost which is of course 1 indexed
                local cost = current[3] + Movecost[unit.moveType][Tilemap[neighbor[1]][neighbor[2]] + 1]
                -- we have to check if enemy units are in the space we want to go to, enemy units block all movement through that space
                -- look here if further optimization is needed, the best solution would be have a seperate tilemap which only denotes if there is a unit on a particular space 
                -- then you would only add one extra check per neighbor rather than #UnitList times many more checks
                for _, otherUnit in ipairs(UnitList) do
                    if otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and otherUnit.team ~= ActivePlayer.color and (not otherUnit.stealth or otherUnit.revealed) then
                        cost = cost + 99
                        break
                    end
                end
                -- we accept a new tile if it would not exceed our range and we have not accepted it before
                if not explored[table.concat(neighbor, ", ")] and cost <= moveCap then
                    explored[table.concat(neighbor, ", ")] = cost
                    -- when we accept a new tile, we must look at all of its neighbors as well, so we add it to the queue
                    frontier:push({neighbor[1], neighbor[2], cost}, cost)
                end
            end
        end
    end
    -- all the tiles we have visited are the ones that are valid for movement
    return explored
end

function FindPath(cameFrom, current, unit)
    local cost = 0
    local totalPath = {{current[1],current[2],cost}}
    while KeyInTable(cameFrom, table.concat(current, ", ")) do
        current = cameFrom[table.concat(current, ", ")]
        cost = cost + Movecost[unit.moveType][Tilemap[current[1]][current[2]] + 1]
        table.insert(totalPath, 1, {current[1],current[2],cost})
    end
    return totalPath
end

function Astar(unit, goal)
    -- feels wrong to have a function that is so similar to the FindPaths above, i strained my brain so hard trying to find a way to implement this inside of that
    -- but for now I guess I will have to run it twice
    -- this function is required for dealing with stealthed units, fog, and displaying the arrow of motion
    -- heuristic is manhattan distance
    -- root and goal should be 2 tables of format {y,x}
    local root = {unit.y, unit.x}
    local function heuristic(a, b)
        return math.abs(a[1] - b[1]) + math.abs(a[2] - b[2])
    end
    local frontier = PriorityQueue:new()
    local cameFrom = {}
    local gScore = {}
    gScore[table.concat(root, ", ")] = 0
    local fScore = {}
    fScore[table.concat(root, ", ")] = heuristic(root,goal)
    frontier:push(root, fScore[table.concat(root, ", ")])

    while frontier.size > 0 do
        local current = frontier:peek()
        if current[1] == goal[1] and current[2] == goal[2] then
            return FindPath(cameFrom, current, unit)
        end
        current = frontier:pop()
        for _, neighbor in ipairs(Adjacent(current[1], current[2])) do
            local tentative_gScore = gScore[table.concat(current, ", ")] + Movecost[unit.moveType][Tilemap[neighbor[1]][neighbor[2]] + 1]
            -- again i really hate having this in here
            -- i really need to find a replacement for this at some point
            -- its purpose is forcing the path to go arround a unit thats blocking it
            for _, otherUnit in ipairs(UnitList) do
                if otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and otherUnit.team ~= ActivePlayer.color and (not otherUnit.stealth or otherUnit.revealed) then
                    tentative_gScore = tentative_gScore + 99
                    break
                end
            end
            if not gScore[table.concat(neighbor, ", ")] then
                gScore[table.concat(neighbor, ", ")] = math.huge
            end
            if tentative_gScore < gScore[table.concat(neighbor, ", ")] then
                cameFrom[table.concat(neighbor, ", ")] = current
                gScore[table.concat(neighbor, ", ")] = tentative_gScore
                fScore[table.concat(neighbor, ", ")] = tentative_gScore + heuristic(neighbor,goal)
                if not TableInTable(frontier.heap, neighbor) then
                    frontier:push(neighbor, fScore[table.concat(neighbor, ", ")])
                end
            end
        end
    end
    return
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
    elseif j == #(Tilemap[1]) then
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

function Range(i,j,range)
    -- likewise i needed this function to give tiles that are "range" distance away for a point (i,j),
    -- the reason that I still use Adjacent(i,j) when Range(i,j,1) would return the same table is because 
    -- just directly returning the table (no for-loops involved at all) is just slightly faster and since FindPaths(unit) is most computationally intensive parts of the program,
    -- I think I need as much optimization for that part as possible, however for other parts like combat where this function is only called once,
    -- not directly returning a table is just fine, it is certain less ugly thats for sure!
    local solutions = {}
    for _, distance in ipairs(range) do
        for y = -distance, distance do
            for x = -distance, distance do
                if math.abs(y) + math.abs(x) == distance then
                    if i+y >= 1 and i+y <= #Tilemap and j+x >= 1 and j+x <= #(Tilemap[1]) then
                        table.insert(solutions, {i+y,j+x})
                    end
                end
            end
        end
    end
    return solutions
end

function FullMap()
    local fullMap = {}
    for i, row in ipairs(Tilemap) do
        for j, _ in ipairs(row) do
            table.insert(fullMap,{i,j})
        end
    end
    return fullMap
end

function Unconcatenate(str, delimiter)
    local function isNumeric(substr)
      return tonumber(substr) ~= nil
    end
    local substrings = {}
    for substring in str:gmatch("[^" .. delimiter .. "]+") do
        if isNumeric(substring) then
          table.insert(substrings, tonumber(substring))
        else
          table.insert(substrings, substring)
        end
    end
    return substrings
end

-- units have different movement costs through different terrain
-- "impossible" movement such as land units through seas are set to 99 move, a number that will never be reached in gameplay
Movecost = {}
Movecost["ship"] =      {01,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,02,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99}
Movecost["transport"] = {01,99,99,99,99,99,99,99,99,99,99,99,99,99,99,01,99,99,99,99,02,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99}
Movecost["air"] =       {01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01}
Movecost["infantry"] =  {99,01,01,01,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,02}
Movecost["mech"] =      {99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01}
Movecost["tire"] =      {99,02,03,01,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99}
Movecost["tread"] =     {99,01,02,01,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99}
Movecost["pipe"] =      {99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,01,01,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99}

TerrainStars =          {00,01,02,03,04,00,03,03,03,03,04,04,03,03,03,00,03,03,03,03,01,03,03,03,03,03,00,00,01,03,03,03,03,03,03,03,03,03,03,03,03,03,03,03,03,03,03,00,00}