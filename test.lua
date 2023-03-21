function FindPaths(unit)
    -- TODO:
    -- Get rid of all the Concatenation nonsense and replace bracket indexing with dot indexing
    -- Document every part of this algorithm
    -- Possible solution could be to only approve to check neighbors that we haven't already approved
    -- get rid of the priority queue, priority is useless
    local start = {unit.y, unit.x}
    local frontier = PriorityQueue:new()
    frontier:push(start,0)
    local cameFrom = {}
    local costSoFar = {}
    cameFrom[table.concat(start,", ")] = nil
    costSoFar[table.concat(start,", ")] = 0
    while frontier.size > 0 do
        local current = frontier:pop()
        for _, neighbor in ipairs(Adjacent(current[1], current[2])) do
            local newCost = costSoFar[table.concat(current,", ")] + Movecost[unit.moveType][Tilemap[neighbor[1]][neighbor[2]] + 1]
            for _, otherUnit in ipairs(UnitList) do
                if otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and otherUnit.team ~= ActivePlayer.color then
                    newCost = newCost + 99
                end
            end
            if (not KeyInTable(costSoFar, neighbor) or newCost < costSoFar[table.concat(neighbor,", ")]) and newCost <= unit.move then
                costSoFar[table.concat(neighbor,", ")] = newCost
                local priority = newCost
                frontier:push(neighbor, priority)
                cameFrom[table.concat(neighbor,", ")] = current
            end
        end
    end
    return cameFrom
end

--[[  1  procedure BFS(G, root) is
 2      let Q be a queue
 3      label root as explored
 4      Q.enqueue(root)
 5      while Q is not empty do
 6          v := Q.dequeue()
 7          if v is the goal then
 8              return v
 9          for all edges from v to w in G.adjacentEdges(v) do
10              if w is not labeled as explored then
11                  label w as explored
12                  w.parent := v
13                  Q.enqueue(w) ]]

print(nil == false)