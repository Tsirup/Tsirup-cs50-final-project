function findPaths(tilemap, start, goal, maxMoves)
    local queue = {{start, 0}} -- Initialize queue with starting tile and number of moves made so far
    local visited = {[start] = 0} -- Keep track of number of moves required to reach each tile
    local current, moves
    while #queue > 0 do
        current, moves = unpack(table.remove(queue, 1)) -- Dequeue a tile and the number of moves required to reach it
        if current == goal then -- If we have reached the end tile, we are done
            break
        end
        if moves >= maxMoves then -- If we have made X moves, we can't reach any more tiles
            break
        end
        for _, neighbor in ipairs(getNeighbors(tilemap, current)) do -- Get the neighboring tiles
            if not visited[neighbor] then -- If we haven't visited the tile yet
                visited[neighbor] = moves + 1 -- Increment the number of moves required to reach the tile
                table.insert(queue, {neighbor, moves + 1}) -- Enqueue the tile and the updated number of moves required
            end
        end
    end
    if not visited[goal] then -- If we haven't reached the end tile, there is no path within X moves
        return nil
    end
    local path = {goal} -- Start with the end tile and work backwards
    current = goal
    while current ~= start do
        for _, neighbor in ipairs(getNeighbors(tilemap, current)) do
            if visited[neighbor] == visited[current] - 1 then -- If the neighbor is one move closer to the start tile
                table.insert(path, neighbor) -- Add the neighbor to the path
                current = neighbor -- Move to the neighbor
                break
            end
        end
    end
    table.reverse(path) -- Reverse the path so that it goes from start to end
    return path
end

function getNeighbors(tilemap, tile)
    -- This function returns a list of the neighboring tiles of `tile`.
    -- The implementation of this function will depend on the specific tilemap data structure being used.
    -- In this example implementation, we assume that the tilemap is a 2D table of booleans, where true represents a passable tile.
    local neighbors = {}
    local x, y = tile[1], tile[2]
    for dx = -1, 1 do
        for dy = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local neighbor = {x + dx, y + dy}
                if tilemap[neighbor[1]] and tilemap[neighbor[1]][neighbor[2]] then
                    table.insert(neighbors, neighbor)
                end
            end
        end
    end
    return neighbors
end
