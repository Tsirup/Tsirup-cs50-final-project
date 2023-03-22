-- one of the the most mathmatically intensive and overall challenging parts of this project
-- this was extremely headache-inducing but i learned a lot about pathfinding alogrithms
-- the alogrithm of choice is Breadth-first alogrithm since we need to look at ALL possible tiles to create the selection of valid tiles
-- if we wanted to only consider one "goal" tile, we should instead use A* alogrithm since its faster on giving us the best possible route to that one tile
-- many older games like Fire Emblem 1 on the NES use this since looking at all possible tiles at once is just too much for the 8-bit system to handle
-- that is why that game has no visible grid when you are moving your characters
-- so you are forced to just move the cursor around to discover your range of movement yourself
-- we have modern technology so we don't have to worry about this
function Movement(unit)
    local validTiles = FindPaths(unit)
    local highlighted = {}
    for key, value in pairs(validTiles) do
        local highlight = Unconcatenate(key,", ")
        table.insert(highlight,value)
        table.insert(highlighted,highlight)
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
                    if otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and otherUnit.team ~= ActivePlayer.color then
                        cost = cost + 99
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
Movecost["ship"] =      {01,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,02,99,99,99,99,99,99,99,99}
Movecost["transport"] = {01,99,99,99,99,99,99,99,99,99,99,99,99,99,99,01,99,99,99,99,02,99,99,99,99,99,99,99,99}
Movecost["air"] =       {01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,99,01}
Movecost["infantry"] =  {99,01,01,01,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,01}
Movecost["mech"] =      {99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,01}
Movecost["tire"] =      {99,02,03,01,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,02}
Movecost["tread"] =     {99,01,02,01,99,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,99,01,01,01,01,01,99,99,01}
Movecost["pipe"] =      {99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,01,01,99}