-- the most mathmatically intensive and overall challenging part of this project
-- this was extremely headache-inducing and i am dissapointed that
-- I had to settle on such a complicated algorithm
function Movement(unit)
    local moved = 0
    local validtiles = {}
    FindPaths(unit.x, unit.y, Cursor.x, Cursor.Y, unit.move)
end

function FindPaths(startx, starty, goalx, goaly, capacity)
    local queue = {{startx, starty, 0}}
    local visited = {[{startx,starty}] = 0}
    local currentx, currenty, moves
    while #queue > 0 do
        currentx, currenty, moves = unpack(table.remove(queue, 1))
        if currentx == goalx and currenty == goaly then
            break
        end
        if moves >= capacity then
            break
        end
        for i, neighbor in ipairs(Adjacent(currenty, currentx)) do
            -- statements
        end
    end
end

-- even though I already have the function Neighbors(i,j)
-- I needed another one to give me just the relevant adjacent tiles
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
            return {Tilemap[i][j+1], Tilemap[i+1][j]}
        end
        if rightedge then
            return {Tilemap[i][j-1],Tilemap[i+1][j-1]}
        end
        return 
            {Tilemap[i][j-1],Tilemap[i][j+1],Tilemap[i+1][j]}
    end
    if botedge then
        if leftedge then
            return
                {Tilemap[i-1][j],Tilemap[i][j+1]}
        end
        if rightedge then
            return {Tilemap[i-1][j],Tilemap[i][j-1]}
        end
        return {Tilemap[i-1][j],Tilemap[i][j-1],Tilemap[i][j+1]}
    end
    if leftedge then
        return {Tilemap[i-1][j],Tilemap[i][j+1],Tilemap[i+1][j]}
    end
    if rightedge then
        return {Tilemap[i-1][j],Tilemap[i][j-1],Tilemap[i+1][j]}
    end
    return {Tilemap[i-1][j],Tilemap[i][j-1],Tilemap[i][j+1],Tilemap[i+1][j]}
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