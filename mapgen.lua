function InTable(table, value)
    for _, v in ipairs(table) do
      if v == value then
        return true
      end
    end
    return false
end

function TableInTable(table, values)
    for _, t in ipairs(table) do
        local match = true
        for i, v in ipairs(values) do
            if t[i] ~= v then
                match = false
                break
            end
        end
        if match then
            return true
        end
    end
    return false
end

function Index(table, value)
    for i, v in ipairs(table) do
        if v == value then
            return i
        end
    end
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
    -- also because about half of the tiles are urban land tiles with shadows, listing what tiles AREN'T these things seems a bit easier
    local notLand = {00, 15, 20, 47, 48}
    local notShadow = {00, 01, 05, 15, 20, 26, 27, 47, 48}
    local notUrban = {00, 01, 02, 04, 15, 20, 26, 27, 28}
    matrix.type = classification
    if matrix.type == "sea" then
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if not InTable(notLand,mtile) then
                    matrix[mi][mj] = 1
                elseif mtile == 48 then
                    matrix[mi][mj] = 2
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
                if mi == 2 and mj == 1 and not InTable(notShadow,mtile) then
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
                if mi == 2 and mj == 1 and not InTable(notShadow,mtile) then
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
                if not InTable(notUrban, mtile) then
                    matrix[mi][mj] = 5
                end
                if mi == 2 and mj == 1 and not InTable(notShadow,mtile) then
                    matrix.shadow = true
                end
            end
        end
    elseif matrix.type == "shoal" then
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if not InTable(notLand, mtile) then
                    matrix[mi][mj] = 1
                elseif mtile ~= 15 then
                    matrix[mi][mj] = 0
                else
                    matrix[mi][mj] = 2
                end
            end
        end
    elseif matrix.type == "pipe" then
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if mtile == 26 or mtile == 27 then
                    matrix[mi][mj] = 1
                else
                    matrix[mi][mj] = 0
                end
            end
        end
    -- same as sea check except no extra exception for other bridges
    elseif matrix.type == "bridge" then
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if not InTable(notLand, mtile) or mtile == 47 then
                    matrix[mi][mj] = 1
                else
                    matrix[mi][mj] = 0
                end
            end
        end
    elseif matrix.type == "river" then
        -- if i add animations, I need to change this to incorporate "river chains"
        for mi, mrow in ipairs(matrix) do
            for mj, mtile in ipairs(mrow) do
                if mtile == 48 or mtile == 47 then
                    matrix[mi][mj] = 1
                else
                    matrix[mi][mj] = 0
                end
            end
        end
    end

    return matrix
end
function MapTranslate(unmap)
    -- to help with the complicated tile translation algorithm, I wrote a Python script (indexer.py) that can take a tilemap with 1 pixel border 
    -- and index them by writing big fat numbers on them, its pretty cool imo

    -- if you are cringing at how long and filled with elseif's this function is, there is no switch statement in lua
    -- but if im still really dumb and theres a better way of doing this, let me know

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
                elseif matrix[2][1] ~= 1 and matrix[2][3] ~= 1 and matrix[3][2] ~= 1 and matrix[1][2] ~= 0 then
                    if matrix[3][1] ~= 1 and matrix[3][3] ~= 1 then
                        if matrix[1][2] == 2 then
                            transmap[i][j] = 1109
                        else
                            transmap[i][j] = 112
                        end
                    elseif matrix[3][3] ~= 1 then
                        transmap[i][j] = 165
                    elseif matrix[3][1] ~= 1 then
                        transmap[i][j] = 163
                    else
                        transmap[i][j] = 164
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][3] ~= 1 and matrix[3][2] ~= 1 and matrix[2][1] ~= 0 then
                    if matrix[1][3] ~= 1 and matrix[3][3] ~= 1 then
                        if matrix[2][1] == 2 then
                            transmap[i][j] = 911
                        else
                            transmap[i][j] = 133
                        end
                    elseif matrix[3][3] ~= 1 then
                        transmap[i][j] = 161
                    elseif matrix[1][3] ~= 1 then
                        transmap[i][j] = 117
                    else
                        transmap[i][j] = 139
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][1] ~= 1 and matrix[3][2] ~= 1 and matrix[2][3] ~= 0 then
                    if matrix[1][1] ~= 1 and matrix[3][1] ~= 1 then
                        if matrix[2][3] == 2 then
                            transmap[i][j] = 1108
                        else
                            transmap[i][j] = 135
                        end
                    elseif matrix[3][1] ~= 1 then
                        transmap[i][j] = 162
                    elseif matrix[1][1] ~= 1 then
                        transmap[i][j] = 118
                    else
                        transmap[i][j] = 140
                    end
                elseif matrix[1][2] ~= 1 and matrix[2][1] ~= 1 and matrix[2][3] ~= 1 and matrix[3][2] ~= 0 then
                    if matrix[1][1] ~= 1 and matrix[1][3] ~= 1 then
                        if matrix[3][2] == 2 then
                            transmap[i][j] = 910
                        else
                            transmap[i][j] = 156
                        end
                    elseif matrix[1][3] ~= 1 then
                        transmap[i][j] = 187
                    elseif matrix[1][1] ~= 1 then
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
                transmap[i][j] = 2096
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
                transmap[i][j] = 2006
            elseif tile == 07 then
                transmap[i][j] = 2024
            elseif tile == 08 then
                transmap[i][j] = 463
            elseif tile == 09 then
                transmap[i][j] = 465
            elseif tile == 10 then
                transmap[i][j] = 2001
            elseif tile == 11 then
                transmap[i][j] = 2020
            elseif tile == 12 then
                transmap[i][j] = 2097
            elseif tile == 13 then
                transmap[i][j] = 2007
            elseif tile == 14 then
                transmap[i][j] = 2025
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
                transmap[i][j] = 2098
            elseif tile == 17 then
                transmap[i][j] = 2099
            elseif tile == 18 then
                transmap[i][j] = 2008
            elseif tile == 19 then
                transmap[i][j] = 2026
            elseif tile == 20 then
                transmap[i][j] = 168
            elseif tile == 21 then
                transmap[i][j] = 2101
            elseif tile == 22 then
                transmap[i][j] = 2102
            elseif tile == 23 then
                transmap[i][j] = 2100
            elseif tile == 24 then
                transmap[i][j] = 2109
            elseif tile == 25 then
                transmap[i][j] = 2027
            elseif tile == 26 then
                local matrix = MatrixTranslate(Neighbors(i,j),"pipe")
                if matrix[2][1] == 1 and matrix[2][3] == 1 then
                    transmap[i][j] = 8
                elseif matrix[1][2] == 1 and matrix[2][1] == 1 then
                    transmap[i][j] = 72
                elseif matrix[1][2] == 1 and matrix[2][3] == 1 then
                    transmap[i][j] = 71
                elseif matrix[1][2] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 9
                elseif matrix[2][1] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 50
                elseif matrix[2][3] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 49
                elseif matrix[1][2] == 1 then
                    transmap[i][j] = 73
                elseif matrix[2][1] == 1 then
                    transmap[i][j] = 75
                elseif matrix[2][3] == 1 then
                    transmap[i][j] = 74
                elseif matrix[3][2] == 1 then
                    transmap[i][j] = 51
                else
                    transmap[i][j] = 8
                end
            elseif tile == 27 then
                local matrix = MatrixTranslate(Neighbors(i,j),"pipe")
                if matrix[2][1] == 1 and matrix[2][3] == 1 then
                    transmap[i][j] = 30
                elseif matrix[1][2] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 31
                else
                    transmap[i][j] = 30
                end
            elseif tile == 28 then
                local matrix = MatrixTranslate(Neighbors(i,j), "pipe")
                if matrix[2][1] == 1 and matrix[2][3] == 1 then
                    transmap[i][j] = 52
                elseif matrix[1][2] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 53
                else
                    transmap[i][j] = 52
                end
            elseif tile == 29 then
                transmap[i][j] = 2042
            elseif tile == 30 then
                transmap[i][j] = 467
            elseif tile == 31 then
                transmap[i][j] = 2039
            elseif tile == 32 then
                transmap[i][j] = 2043
            elseif tile == 33 then
                transmap[i][j] = 2044
            elseif tile == 34 then
                transmap[i][j] = 2045
            elseif tile == 35 then
                transmap[i][j] = 2060
            elseif tile == 36 then
                transmap[i][j] = 469
            elseif tile == 37 then
                transmap[i][j] = 2058
            elseif tile == 38 then
                transmap[i][j] = 2061
            elseif tile == 39 then
                transmap[i][j] = 2062
            elseif tile == 40 then
                transmap[i][j] = 2063
            elseif tile == 41 then
                transmap[i][j] = 2078
            elseif tile == 42 then
                transmap[i][j] = 471
            elseif tile == 43 then
                transmap[i][j] = 2077
            elseif tile == 44 then
                transmap[i][j] = 2079
            elseif tile == 45 then
                transmap[i][j] = 2080
            elseif tile == 46 then
                transmap[i][j] = 2081
            elseif tile == 47 then
                local matrix = MatrixTranslate(Neighbors(i,j), "bridge")
                if matrix[2][1] == 1 and matrix[2][3] == 1 then
                    transmap[i][j] = 78
                elseif matrix[1][2] == 1 and matrix[3][2] == 1 then
                    transmap[i][j] = 79
                elseif matrix[2][1] == 1 or matrix[2][3] == 1 then
                    transmap[i][j] = 78
                elseif matrix[1][2] == 1 or matrix[3][2] == 1 then
                    transmap[i][j] = 79
                else
                    transmap[i][j] = 78
                end
            elseif tile == 48 then
                -- structure borrowed from roads
                -- ALL rivers flow south or west right now
                -- if i add map animations later, I MUST CHANGE THIS, preferably in another function after map translation similar to ForestCombine()
                -- expect it to be HARD, i've noticed that some tiles of river tiles that should exist just don't
                -- for instance there is only one type of 4-way junction (all streams merging south) and even stranger,
                -- there are tiles that exist that i have never seen in the game before, like a river tile that meets the sea without a waterfall but only facing north
                -- no other tile is this weird and difficult to understand, i am very lucky that i am not implementing world animations or i would be really screwed
                -- with my current configuration of only flowing south or west, two specific tiles, (north-to-east corner tile and 4-way junction) are not compatible
                -- there is really nothing i can do about it without adding the flow system which i would just really really not like to do, 
                -- i think perhaps i could make a custom tile that fixes it, even that would be preferable,
                -- it is definitely one of the first things i will consider when working on version 2 of this game if i get to it
                local matrix = MatrixTranslate(Neighbors(i,j), "river")
                if matrix[1][2] ~= 1 and matrix[3][2] ~= 1 then
                    transmap[i][j] = 708
                elseif matrix[2][1] ~= 1 and matrix[2][3] ~= 1 then
                    transmap[i][j] = 507
                elseif matrix[2][3] ~= 1 and matrix[3][2] ~= 1 then
                    transmap[i][j] = 1114
                elseif matrix[2][1] ~= 1 and matrix[3][2] ~= 1 then
                    -- the bad corner tile mentioned above, i am sending it up instead of right arbitrarily, they both look bad
                    transmap[i][j] = 709
                elseif matrix[1][2] ~= 1 and matrix[2][3] ~= 1 then
                    transmap[i][j] = 920
                elseif matrix[1][2] ~= 1 and matrix[2][1] ~= 1 then
                    transmap[i][j] = 525
                elseif matrix[3][2] ~= 1 then
                    transmap[i][j] = 1112
                elseif matrix[2][3] ~= 1 then
                    transmap[i][j] = 913
                    -- this one is facing the wrong way on purpose because the one for the other direction just looks bad, no idea why
                elseif matrix[2][1] ~= 1 then
                    transmap[i][j] = 907
                elseif matrix[1][2] ~= 1 then
                    transmap[i][j] = 917
                else
                    -- the bad 4 way junction
                    -- it looks bad from the west because it only takes rivers flowing east from that side, which we are not considering at this time
                    transmap[i][j] = 711
                end
            else
                transmap[i][j] = 0
            end
        end
    end
    transmap = ForestCombine(transmap)
    return transmap
end

function ForestCombine(uncmap)
    local forest = {2,3}
    for i, row in ipairs(uncmap) do
        for j, tile in ipairs(row) do
            if InTable(forest, tile) then
                local matrix = MatrixTranslate(Neighbors(i,j), "wood")
                if matrix.shadow == false and matrix.square == false then
                    uncmap[i][j] = 2
                elseif matrix.square == false then
                    uncmap[i][j] = 3
                elseif matrix.big_square == true then
                    local big_square_neighbors = {uncmap[i-1][j-1], uncmap[i-1][j], uncmap[i-1][j+1], uncmap[i][j-1], uncmap[i][j+1], uncmap[i+1][j-1], uncmap[i+1][j], uncmap[i+1][j+1]}
                    if AllInTable(forest,big_square_neighbors) then
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
    local income, hq
    local props = {}
    Players = {}
    City, Base, HQ, Airport, Port, Lab = {3}, {12}, {nil}, {16}, {17}, {23}
    Property = {3, 12, 16, 17, 23}
    for _, row in ipairs(Tilemap) do
        for _, tile in ipairs(row) do
            table.insert(csvmap, tile)
        end
    end
    if InTable(csvmap, 10) or InTable(csvmap, 24) then
        props = {6, 8, 10, 13, 18, 24}
        CombineTable(Property, props)
        income = CountInTable(csvmap, props) * 1000
        if InTable(csvmap, 10) then
            hq = 10
        else
            hq = nil
        end
        table.insert(Players, {order = 1, color = "Red", money = 0, income = income, props = props, production = {08,13,18}, HQ = hq})
    end
    if InTable(csvmap, 11) or InTable(csvmap, 25) then
        props = {7, 9, 11, 14, 19, 25}
        CombineTable(Property, props)
        income = CountInTable(csvmap, props) * 1000
        if InTable(csvmap, 11) then
            hq = 11
        else
            hq = nil
        end
        table.insert(Players, {order = 2, color = "Blue", money = 0, income = income, props = props, production = {09,14,19}, HQ = hq})
    end
    if InTable(csvmap, 31) or InTable(csvmap, 34) then
        props = {29, 30, 31, 32, 33, 34}
        CombineTable(Property, props)
        income = CountInTable(csvmap, props) * 1000
        if InTable(csvmap, 31) then
            hq = 31
        else
            hq = nil
        end
        table.insert(Players, {order = 3, color = "Yellow", money = 0, income = income, props = props, production = {30,32,33}, HQ = hq})
    end
    if InTable(csvmap, 37) or InTable(csvmap, 40) then
        props = {35, 36, 37, 38, 39, 40}
        CombineTable(Property, props)
        income = CountInTable(csvmap, props) * 1000
        if InTable(csvmap, 37) then
            hq = 37
        else
            hq = nil
        end
        table.insert(Players, {order = 4, color = "Green", money = 0, income = income, props = props, production = {36,38,39}, HQ = hq})
    end
    if InTable(csvmap, 43) or InTable(csvmap, 46) then
        props = {41, 42, 43, 44, 45, 46}
        CombineTable(Property, props)
        income = CountInTable(csvmap, props) * 1000
        if InTable(csvmap, 43) then
            hq = 43
        else
            hq = nil
        end
        table.insert(Players, {order = 5, color = "Black", money = 0, income = income, props = props, production = {42,44,45}, HQ = hq})
    end
    for _, player in ipairs(Players) do
        table.insert(City, player.props[1])
        table.insert(Base, player.props[2])
        table.insert(HQ, player.props[3])
        table.insert(Airport, player.props[4])
        table.insert(Port, player.props[5])
        table.insert(Lab, player.props[6])
        if player.HQ then
            for i, row in ipairs(Tilemap) do
                for j, tile in ipairs(row) do
                    if tile == player.HQ then
                        player.HQ = {i,j}
                        goto nextPlayer
                    end
                end
            end
        end
        ::nextPlayer::
    end
    ActivePlayer = Players[1]
    ActivePlayer.money = income
end

-- i have no idea if this will work or not, but as of right now, I have no maps with pipe seams and i dont intend to add any for the foreseeable future
function Interactive()
    for i, row in ipairs(Tilemap) do
        for j, tile in ipairs(row) do
            if tile == 27 then
                PipeSeam(i,j)
            end
        end
    end
end