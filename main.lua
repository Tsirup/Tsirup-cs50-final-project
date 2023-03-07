---@diagnostic disable: duplicate-set-field
if arg[2] == "debug" then
    require("lldebugger").start()
end
function love.load()

    Width = 16
    Height = 16
    World_quads = {}
    Prop_quads = {}
    Unit_quads = {}
    Icon_quads = {}

    -- I modified these tilemaps with microsoft paint from the great templates at spriters-resource.com
    Overworld = love.graphics.newImage("graphics/overworld2bordertransparent.png")
    local image_width = Overworld:getWidth()
    local image_height = Overworld:getHeight()

    for i=0,21 do
        for j=0,21 do
            table.insert(World_quads,
                love.graphics.newQuad(
                    1 + j * (Width + 2),
                    1 + i * (Height + 2),
                    Width, Height,
                    image_width, image_height))
        end
    end

    Properties = love.graphics.newImage("graphics/properties2bordertransparent.png")
    image_width = Properties:getWidth()
    image_height = Properties:getHeight()

    for i=0,5 do
        for j=0,17 do
            table.insert(Prop_quads,
                love.graphics.newQuad(
                    1 + j * (Width + 2),
                    1 + i * (2 * Height + 2),
                    Width, 2 * Height,
                    image_width, image_height))
        end
    end

    Units = love.graphics.newImage("graphics/units.png")
    image_width = Units:getWidth()
    image_height = Units:getHeight()

    for i=0,26 do
        for j=0,29 do
            table.insert(Unit_quads,
                love.graphics.newQuad(
                    1 + j * (Width + 1),
                    1 + i * (Height + 1),
                    Width, Height,
                    image_width, image_height))
        end
    end

    Icons = love.graphics.newImage("graphics/icons.png")
    image_width = Icons:getWidth()
    image_height = Icons:getHeight()

    for i=0,4 do
        for j=0,27 do
            table.insert(Icon_quads,
                love.graphics.newQuad(
                    1 + j * (Width / 2 + 1),
                    1 + i * (Height / 2 + 1),
                    Width / 2, Height / 2,
                    image_width, image_height))
        end
    end
    -- map keys in keys.txt
    -- map files in maps folder, put whatever map you want here
    require("maps/CraterIsle")

    Transmap = MapTranslate(Tilemap)
end

function InTable(table, value)
    for i, v in ipairs(table) do
      if v == value then
        return true
      end
    end
    return false
end

function AllInTable(table, values)
    for i, v in ipairs(values) do
        if not InTable(table, v) then
            return false
        end
    end
    return true
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
    local land = {01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14}
    local shadow = {02, 03, 04, 06, 07, 08, 09, 10, 11, 12, 13, 14}
    matrix.type = classification
    if matrix.type == "sea" then
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

function love.draw()
    -- to avoid bleeding upon scale, i wrote another python script which changes the borders of a spritemap to be the same color as the "actual border"
    -- check it out at border.py

    -- to properly layer the appropriate quads on top of one another, i wrote another python scipt which makes a particular RGBA value transparent
    -- check it out at transparent.py

    -- temporary scale for dev purposes
    love.graphics.scale(2,2)
    for i,row in ipairs(Transmap) do
        for j,tile in ipairs(row) do
            if tile > 0 then
                if tile < 463 then
                    love.graphics.draw(Overworld, World_quads[tile], j * Width, i * Height)
                elseif tile < 2001 then
                    love.graphics.draw(Overworld, World_quads[1], j * Width, i * Height)
                    if tile < 485 then
                        love.graphics.draw(Overworld, World_quads[tile], j * Width, i * Height)
                        love.graphics.draw(Overworld, World_quads[473], j * Width, (i-1) * Height)
                    else
                        love.graphics.draw(Properties, Prop_quads[tile-1000], j * Width, (i-1) * Height)
                    end
                end
            end
        end
    end
end

---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
---@diagnostic disable-next-line: undefined-global
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end