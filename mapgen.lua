function InTable(table, value)
    for _, v in ipairs(table) do
      if v == value then
        return true
      end
    end
    return false
end

function AllInTable(table, values)
    for _, v in ipairs(values) do
        if not InTable(table, v) then
            return false
        end
    end
    return true
end

function KeyInTable(table, key)
    return table[key] ~= nil
end

function CountInTable(table, values)
    local count = 0
    for _, v in ipairs(table) do
        for _, value in ipairs(values) do
            if v == value then
                count = count + 1
            end
        end
    end
    return count
end

function CombineTable(table1,table2)
    for _, v in ipairs(table2) do
        table.insert(table1, v)
    end
end

function Neighbors(i,j)
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
            return {
                {0,0,0},
                {0,Tilemap[i][j],Tilemap[i][j+1]},
                {0,Tilemap[i+1][j],Tilemap[i+1][j+1]}}
        end
        if rightedge then
            return {
                {0,0,0},
                {Tilemap[i][j-1],Tilemap[i][j],0},
                {Tilemap[i+1][j-1],Tilemap[i+1][j],0}}
        end
        return {
            {0,0,0},
            {Tilemap[i][j-1],Tilemap[i][j],Tilemap[i][j+1]},
            {Tilemap[i+1][j-1],Tilemap[i+1][j],Tilemap[i+1][j+1]}}
    end
    if botedge then
        if leftedge then
            return {
                {0,Tilemap[i-1][j],Tilemap[i-1][j+1]},
                {0,Tilemap[i][j],Tilemap[i][j+1]},
                {0,0,0}}
        end
        if rightedge then
            return {
                {Tilemap[i-1][j-1],Tilemap[i-1][j],0},
                {Tilemap[i][j-1],Tilemap[i][j],0},
                {0,0,0}}
        end
        return {
            {Tilemap[i-1][j-1],Tilemap[i-1][j],Tilemap[i-1][j+1]},
            {Tilemap[i][j-1],Tilemap[i][j],Tilemap[i][j+1]},
            {0,0,0}}
    end
    if leftedge then
        return {
            {0,Tilemap[i-1][j],Tilemap[i-1][j+1]},
            {0,Tilemap[i][j],Tilemap[i][j+1]},
            {0,Tilemap[i+1][j],Tilemap[i+1][j+1]}}
    end
    if rightedge then
        return {
            {Tilemap[i-1][j-1],Tilemap[i-1][j],0},
            {Tilemap[i][j-1],Tilemap[i][j],0},
            {Tilemap[i+1][j-1],Tilemap[i+1][j],0}}
    end
    return {
        {Tilemap[i-1][j-1],Tilemap[i-1][j],Tilemap[i-1][j+1]},
        {Tilemap[i][j-1],Tilemap[i][j],Tilemap[i][j+1]},
        {Tilemap[i+1][j-1],Tilemap[i+1][j],Tilemap[i+1][j+1]}}
end

function MatrixTranslate(matrix,classification)
    -- these are written explicitly because i have keyed the values by their prevelence as can be seen in keys.txt,
    -- not on their relationship to eachother, so past around 15 it gets a little random how they are classified
    local land = {01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 16, 17, 18, 19, 21, 22, 23, 24, 25}
    local shadow = {02, 03, 04, 06, 07, 08, 09, 10, 11, 12, 13, 14, 16, 17, 18, 19, 21, 22, 23, 24, 25}
    matrix.type = classification
    if matrix.type == "sea" then
        -- for sea tiles and only sea tiles, ports are not considered land tiles
        table.remove(land, 18)
        table.remove(land, 17)
        table.remove(land, 16)
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if InTable(land,mtile) then
                    matrix[mi][mj] = 1
                else
                    matrix[mi][mj] = 0
                end
            end
        end
    elseif matrix.type == "plain" then
        matrix.shadow = false
        matrix.mountain = false
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if mi == 2 and mj == 1 and InTable(shadow,mtile) then
                    matrix.shadow = true
                end
                if mi == 3 and mj == 2 and mtile == 04 then
                    matrix.mountain = true
                end
            end
        end
    elseif matrix.type == "wood" then
        matrix.square = true
        matrix.big_square = true
        matrix.shadow = false
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if mi == 2 and mj == 1 and InTable(shadow,mtile) then
                    matrix.shadow = true
                end
                if mtile ~= 02 and (mi < 3 and mj < 3) and matrix.square then
                    matrix.square = false
                    matrix.big_square = false
                elseif mtile ~= 02 and matrix.big_square then
                    matrix.big_square = false
                end
            end
        end
    elseif matrix.type == "mtn" then
        matrix.mountain = false
        matrix.big = false
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if mi == 3 and mj == 2 and mtile == 04 then
                    matrix.mountain = true
                end
                if mi == 1 and mj == 2 and (mtile == 01 or mtile == 04) then
                    matrix.big = true
                end
            end
        end
    elseif matrix.type == "road" then
        matrix.shadow = false
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if mi == 2 and mj == 1 and InTable(shadow,mtile) then
                    matrix.shadow = true
                end
            end
        end
    elseif matrix.type == "shoal" then
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if InTable(land, mtile) then
                    matrix[mi][mj] = 1
                elseif mtile ~= 15 then
                    matrix[mi][mj] = 0
                else
                    matrix[mi][mj] = 2
                end
            end
        end
    end

    return matrix
end
function MapTranslate(unmap)
    -- to help with the complicated tile translation algorithm, I wrote a Python script (indexer.py) that can take a tilemap with 1 pixel border 
    -- and index them by writing big fat numbers on them, its pretty cool imo

    -- create a new map and fill it with zeroes
    local transmap = {}
    for i, row in ipairs(unmap) do
        table.insert(transmap, {})
        for j, tile in ipairs(row) do
            table.insert(transmap[i], 0)
        end
    end
    for i, row in ipairs(unmap) do
        for j, tile in ipairs(row) do
            if tile == 0 then
                local matrix = MatrixTranslate(Neighbors(i,j),"sea")
                if matrix[1][2] == 0 and matrix[2][1] == 0 and matrix[2][3] == 0 and matrix[3][2] == 0 then
                    if matrix[1][1] == 0 and matrix[1][3] == 0 and matrix[3][1] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 134
                    elseif matrix[1][3] == 0 and matrix[3][1] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 138
                    elseif matrix[1][1] == 0 and matrix[3][1] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 137
                    elseif matrix[1][1] == 0 and matrix[1][3] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 116
                    elseif matrix[1][1] == 0 and matrix[1][3] == 0 and matrix[3][1] == 0 then
                        transmap[i][j] = 115
                    elseif matrix[3][1] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 119
                    elseif matrix[1][3] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 141
                    elseif matrix[1][3] == 0 and matrix[3][1] == 0 then
                        transmap[i][j] = 183
                    elseif matrix[1][1] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 184
                    elseif matrix[1][1] == 0 and matrix[3][1] == 0 then
                        transmap[i][j] = 120
                    elseif matrix[1][1] == 0 and matrix[1][3] == 0 then
                        transmap[i][j] = 142
                    elseif matrix[3][3] == 0 then
                        transmap[i][j] = 144
                    elseif matrix[3][1] == 0 then
                        transmap[i][j] = 143
                    elseif matrix[1][3] == 0 then
                        transmap[i][j] = 122
                    elseif matrix[1][1] == 0 then
                        transmap[i][j] = 121
                    else
                        transmap[i][j] = 166
                    end
                elseif matrix[2][1] == 0 and matrix[2][3] == 0 and matrix[3][2] == 0 then
                    if matrix[3][1] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 112
                    elseif matrix[3][3] == 0 then
                        transmap[i][j] = 165
                    elseif matrix[3][1] == 0 then
                        transmap[i][j] = 163
                    else
                        transmap[i][j] = 164
                    end
                elseif matrix[1][2] == 0 and matrix[2][3] == 0 and matrix[3][2] == 0 then
                    if matrix[1][3] == 0 and matrix[3][3] == 0 then
                        transmap[i][j] = 133
                    elseif matrix[3][3] == 0 then
                        transmap[i][j] = 161
                    elseif matrix[1][3] == 0 then
                        transmap[i][j] = 117
                    else
                        transmap[i][j] = 139
                    end
                elseif matrix[1][2] == 0 and matrix[2][1] == 0 and matrix[3][2] == 0 then
                    if matrix[1][1] == 0 and matrix[3][1] == 0 then
                        transmap[i][j] = 135
                    elseif matrix[3][1] == 0 then
                        transmap[i][j] = 162
                    elseif matrix[1][1] == 0 then
                        transmap[i][j] = 118
                    else
                        transmap[i][j] = 140
                    end
                elseif matrix[1][2] == 0 and matrix[2][1] == 0 and matrix[2][3] == 0 then
                    if matrix[1][1] == 0 and matrix[1][3] == 0 then
                        transmap[i][j] = 156
                    elseif matrix[1][3] == 0 then
                        transmap[i][j] = 187
                    elseif matrix[1][1] == 0 then
                        transmap[i][j] = 185
                    else
                        transmap[i][j] = 186
                    end
                elseif matrix[2][3] == 0 and matrix[3][2] == 0 then
                    if matrix[3][3] == 0 then
                        transmap[i][j] = 111
                    else
                        transmap[i][j] = 159
                    end
                elseif matrix[2][1] == 0 and matrix[3][2] == 0 then
                    if matrix[3][1] == 0 then
                        transmap[i][j] = 113
                    else
                        transmap[i][j] = 160
                    end
                elseif matrix[1][2] == 0 and matrix[2][3] == 0 then
                    if matrix[1][3] == 0 then
                        transmap[i][j] = 155
                    else
                        transmap[i][j] = 181
                    end
                elseif matrix[1][2] == 0 and matrix[2][1] == 0 then
                    if matrix[1][1] == 0 then
                        transmap[i][j] = 157
                    else
                        transmap[i][j] = 182
                    end
                elseif matrix[2][1] == 0 and matrix[2][3] == 0 then
                    transmap[i][j] = 178
                elseif matrix[1][2] == 0 and matrix[3][2] == 0 then
                    transmap[i][j] = 136
                elseif matrix[3][2] == 0 then
                    transmap[i][j] = 114
                elseif matrix[2][3] == 0 then
                    transmap[i][j] = 177
                elseif matrix[2][1] == 0 then
                    transmap[i][j] = 179
                elseif matrix[1][2] == 0 then
                    transmap[i][j] = 158
                else
                    transmap[i][j] = 180
                end
            elseif tile == 01 then
                local matrix = MatrixTranslate(Neighbors(i,j),"plain")
                if matrix.shadow == false and matrix.mountain == false then
                    transmap[i][j] = 1
                elseif matrix.mountain == false then
                    transmap[i][j] = 4
                elseif matrix.shadow == false then
                    transmap[i][j] = 27
                else
                    transmap[i][j] = 6
                end
            elseif tile == 02 then
                -- forest squares outsourced to combine function
                local matrix = MatrixTranslate(Neighbors(i,j),"wood")
                if matrix.shadow == false then
                    transmap[i][j] = 2
                else
                    transmap[i][j] = 3
                end
            elseif tile == 03 then
                transmap[i][j] = 1096
            elseif tile == 04 then
                local matrix = MatrixTranslate(Neighbors(i,j),"mtn")
                if matrix.mountain == false and matrix.big == false then
                    transmap[i][j] = 5
                elseif matrix.big == false then
                    transmap[i][j] = 7
                elseif matrix.mountain == false then
                    transmap[i][j] = 28
                else
                    transmap[i][j] = 29
                end
            elseif tile == 05 then
                local matrix = MatrixTranslate(Neighbors(i,j),"road")
                if matrix[1][2] ~= 5 and matrix[3][2] ~= 5 then
                    if matrix[2][1] == 5 and matrix[2][3] ~= 5 then
                        if matrix.shadow == false then
                            transmap[i][j] = 99
                        else
                            transmap[i][j] = 102
                        end
                    elseif matrix[2][3] == 5 and matrix[2][1] ~= 5 then
                        if matrix.shadow == false then
                            transmap[i][j] = 98
                        else
                            transmap[i][j] = 101
                        end
                    else
                        if matrix.shadow == false then
                            transmap[i][j] = 76
                        else 
                            transmap[i][j] = 80
                        end
                    end
                elseif matrix[2][1] ~= 5 and matrix[2][3] ~= 5 then
                    if matrix[1][2] ~= 5 then
                        if matrix.shadow == false then
                            transmap[i][j] = 100
                        else
                            transmap[i][j] = 103
                        end
                    else
                        if matrix.shadow == false then
                            transmap[i][j] = 77
                        else 
                            transmap[i][j] = 81
                        end
                    end
                elseif matrix[2][3] ~= 5 and matrix[3][2] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 56
                    else
                        transmap[i][j] = 59
                    end
                elseif matrix[2][1] ~= 5 and matrix[3][2] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 54
                    else
                        transmap[i][j] = 57
                    end
                elseif matrix[1][2] ~= 5 and matrix[2][3] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 12
                    else
                        transmap[i][j] = 15
                    end
                elseif matrix[1][2] ~= 5 and matrix[2][1] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 10
                    else
                        transmap[i][j] = 13
                    end
                elseif matrix[3][2] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 55
                    else
                        transmap[i][j] = 58
                    end
                elseif matrix[2][3] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 34
                    else
                        transmap[i][j] = 37
                    end
                elseif matrix[2][1] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 32
                    else
                        transmap[i][j] = 35
                    end
                elseif matrix[1][2] ~= 5 then
                    if matrix.shadow == false then
                        transmap[i][j] = 11
                    else
                        transmap[i][j] = 14
                    end
                else
                    if matrix.shadow == false then
                        transmap[i][j] = 33
                    else
                        transmap[i][j] = 36
                    end
                end
            elseif tile == 06 then
                transmap[i][j] = 1006
            elseif tile == 07 then
                transmap[i][j] = 1024
            elseif tile == 08 then
                transmap[i][j] = 463
            elseif tile == 09 then
                transmap[i][j] = 465
            elseif tile == 10 then
                transmap[i][j] = 1001
            elseif tile == 11 then
                transmap[i][j] = 1020
            elseif tile == 12 then
                transmap[i][j] = 1097
            elseif tile == 13 then
                transmap[i][j] = 1007
            elseif tile == 14 then
                transmap[i][j] = 1025
            elseif tile == 15 then
                local matrix = MatrixTranslate(Neighbors(i,j),"shoal")
                if matrix[1][2] == 1 and matrix[2][1] ~= 1 and matrix[2][3] ~= 1 and matrix[3][2] ~= 1 then
                    if matrix[2][1] == 0 and matrix[2][3] == 0 then
                        transmap[i][j] = 154
                    elseif matrix[2][1] == 2 and matrix[2][3] == 0 then
                        transmap[i][j] = 153
                    elseif matrix[2][1] == 0 and matrix[2][3] == 2 then
                        transmap[i][j] = 152
                    else
                        transmap[i][j] = 146
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][1] == 1 and matrix[2][3] ~= 1 and matrix[3][2] ~= 1 then
                    if matrix[1][2] == 0 and matrix[3][2] == 0 then
                        transmap[i][j] = 193
                    elseif matrix[1][2] == 2 and matrix[3][2] == 0 then
                        transmap[i][j] = 171
                    elseif matrix[1][2] == 0 and matrix[3][2] == 2 then
                        transmap[i][j] = 149
                    else
                        transmap[i][j] = 167
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][1] ~= 1 and matrix[2][3] == 1 and matrix[3][2] ~= 1 then
                    if matrix[1][2] == 0 and matrix[3][2] == 0 then
                        transmap[i][j] = 192
                    elseif matrix[1][2] == 2 and matrix[3][2] == 0 then
                        transmap[i][j] = 170
                    elseif matrix[1][2] == 0 and matrix[3][2] == 2 then
                        transmap[i][j] = 148
                    else
                        transmap[i][j] = 169
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][1] ~= 1 and matrix[2][3] ~= 1 and matrix[3][2] == 1 then
                    if matrix[2][1] == 0 and matrix[2][3] == 0 then
                        transmap[i][j] = 132
                    elseif matrix[2][1] == 2 and matrix[2][3] == 0 then
                        transmap[i][j] = 131
                    elseif matrix[2][1] == 0 and matrix[2][3] == 2 then
                        transmap[i][j] = 130
                    else
                        transmap[i][j] = 190
                    end
                elseif matrix[1][2] == 1 and matrix[2][1] == 1 and matrix[2][3] ~= 1 and matrix[3][2] ~= 1 then
                    if matrix[2][3] == 0 and matrix[3][2] == 0 then
                        transmap[i][j] = 129
                    elseif matrix[2][3] == 2 and matrix[3][2] == 0 then
                        transmap[i][j] = 196
                    elseif matrix[2][3] == 0 and matrix[3][2] == 2 then
                        transmap[i][j] = 151
                    else
                        transmap[i][j] = 145
                    end
                elseif matrix[1][2] == 1 and matrix[2][1] ~= 1 and matrix[2][3] == 1 and matrix[3][2] ~= 1 then
                    if matrix[2][1] == 0 and matrix[3][2] == 0 then
                        transmap[i][j] = 126
                    elseif matrix[2][1] == 2 and matrix[3][2] == 0 then
                        transmap[i][j] = 197
                    elseif matrix[2][1] == 0 and matrix[3][2] == 2 then
                        transmap[i][j] = 150
                    else
                        transmap[i][j] = 147
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][1] == 1 and matrix[2][3] ~= 1 and matrix[3][2] == 1 then
                    if matrix[1][2] == 0 and matrix[2][3] == 0 then
                        transmap[i][j] = 127
                    elseif matrix[1][2] == 2 and matrix[2][3] == 0 then
                        transmap[i][j] = 173
                    elseif matrix[1][2] == 0 and matrix[2][3] == 2 then
                        transmap[i][j] = 174
                    else
                        transmap[i][j] = 189
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][1] ~= 1 and matrix[2][3] == 1 and matrix[3][2] == 1 then
                    if matrix[1][2] == 0 and matrix[2][1] == 0 then
                        transmap[i][j] = 128
                    elseif matrix[1][2] == 2 and matrix[2][1] == 0 then
                        transmap[i][j] = 172
                    elseif matrix[1][2] == 0 and matrix[2][1] == 2 then
                        transmap[i][j] = 175
                    else
                        transmap[i][j] = 191
                    end
                elseif matrix[1][2] == 1 and matrix[2][1] == 1 and matrix[2][3] == 1 and matrix[3][2] ~= 1 then
                    transmap[i][j] = 198
                elseif matrix[1][2] == 1 and matrix[2][1] == 1 and matrix[2][3] ~= 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 195
                elseif matrix[1][2] == 1 and matrix[2][1] ~= 1 and matrix[2][3] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 194
                elseif matrix[1][2] ~= 1 and matrix[2][1] == 1 and matrix[2][3] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 176
                else
                    -- shoals are special tiles in that they MUST be adjacent to one land tile and one non-land tile at the same time
                    -- also strangely shoals cannot be between 2 lands and 2 non-lands at the same time
                    -- in these cases, im just not gonna render anything
                    transmap[i][j] = 0
                end
            elseif tile == 16 then
                transmap[i][j] = 1098
            elseif tile == 17 then
                transmap[i][j] = 1099
            elseif tile == 18 then
                transmap[i][j] = 1008
            elseif tile == 19 then
                transmap[i][j] = 1026
            elseif tile == 20 then
                transmap[i][j] = 168
            elseif tile == 21 then
                transmap[i][j] = 1101
            elseif tile == 22 then
                transmap[i][j] = 1102
            elseif tile == 23 then
                transmap[i][j] = 1100
            elseif tile == 24 then
                transmap[i][j] = 1109
            elseif tile == 25 then
                transmap[i][j] = 1027
            else
                transmap[i][j] = 0
            end
        end
    end
    transmap = Combine(transmap)
    return transmap
end

function Combine(uncmap)
    local forest = {2,3}
    for i, row in ipairs(uncmap) do
        for j, tile in ipairs(row) do
            if InTable(forest, tile) then
                local matrix = MatrixTranslate(Neighbors(i,j), "wood")
                -- mess around in testmap, change to check downstream instead of upstream(?)
                if matrix.shadow == false and matrix.square == false then
                    uncmap[i][j] = 2
                elseif matrix.square == false then
                    uncmap[i][j] = 3
                elseif matrix.big_square == true then
                    uncmap[i+1][j+1] = 69
                    uncmap[i][j+1] = 47
                    uncmap[i-1][j+1] = 25
                    uncmap[i+1][j] = 68
                    uncmap[i][j] = 46
                    uncmap[i-1][j] = 24
                    if uncmap[i+1][j-1] == 3 then
                        uncmap[i+1][j-1] = 70
                    else 
                        uncmap[i+1][j-1] = 67
                    end
                    if uncmap[i][j-1] == 3 then
                        uncmap[i][j-1] = 48
                    else
                        uncmap[i][j-1] = 45
                    end
                    if uncmap[i-1][j-1] == 3 then
                        uncmap[i-1][j-1] = 26
                    else
                        uncmap[i-1][j-1] = 23
                    end
                elseif matrix.square == true then
                    local square_neighbors = {uncmap[i-1][j], uncmap[i][j-1], uncmap[i-1][j-1]}
                    if AllInTable(forest,square_neighbors) then
                        uncmap[i][j] = 69
                        uncmap[i-1][j] = 25
                        if uncmap[i][j-1] == 3 then
                            uncmap[i][j-1] = 70
                        else
                            uncmap[i][j-1] = 67
                        end
                        if uncmap[i-1][j-1] == 3 then
                            uncmap[i-1][j-1] = 26
                        else
                            uncmap[i-1][j-1] = 23
                        end
                    end
                end
            end
        end
    end
    return uncmap
end

-- possible players and the starting player
function PlayerGen()
    local csvmap = {}
    local income, bases
    Players = {}
    Property = {}
    for _, row in ipairs(Tilemap) do
        for _, tile in ipairs(row) do
            table.insert(csvmap, tile)
        end
    end
    if InTable(csvmap, 10) or InTable(csvmap, 24) then
        bases = {6, 8, 10, 13, 18, 24}
        CombineTable(Property, bases)
        income = CountInTable(csvmap, bases) * 1000
        table.insert(Players, {color = "red", money = 0, income = income, bases = bases})
    end
    if InTable(csvmap, 11) or InTable(csvmap, 25) then
        bases = {7, 9, 11, 14, 19, 25}
        CombineTable(Property, bases)
        income = CountInTable(csvmap, bases) * 1000
        table.insert(Players, {color = "blue", money = 0, income = income, bases = bases})
    end
    Active_Player = Players[Turn]
    Active_Player.money = income
end