hqx = math.ceil(Index(csvmap,10) % #Tilemap[1])
        if hqx == 0 then
            hqx = #Tilemap[1]
        end
        hqy = math.ceil(Index(csvmap,10) / #Tilemap[1])