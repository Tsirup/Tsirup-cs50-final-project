if matrix[1][2] ~= 1 and matrix[2][1] ~= 1 and matrix[2][3] ~= 1 and matrix[3][2] ~= 1 then
    if matrix[1][1] ~= 1 and matrix[1][3] ~= 1 and matrix[3][1] ~= 1 and matrix[3][3] ~= 1 then
        transmap[i][j] = 134
    elseif matrix[1][3] ~= 1 and matrix[3][1] ~= 1 and matrix[3][3] ~= 1 then
        transmap[i][j] = 138
    elseif matrix[1][1] ~= 1 and matrix[3][1] ~= 1 and matrix[3][3] ~= 1 then
        transmap[i][j] = 137
    elseif matrix[1][1] ~= 1 and matrix[1][3] ~= 1 and matrix[3][3] ~= 1 then
        transmap[i][j] = 116
    elseif matrix[1][1] ~= 1 and matrix[1][3] ~= 1 and matrix[3][1] ~= 1 then
        transmap[i][j] = 115
    elseif matrix[3][1] ~= 1 and matrix[3][3] ~= 1 then
        transmap[i][j] = 119
    elseif matrix[1][3] ~= 1 and matrix[3][3] ~= 1 then
        transmap[i][j] = 141
    elseif matrix[1][3] ~= 1 and matrix[3][1] ~= 1 then
        transmap[i][j] = 183
    elseif matrix[1][1] ~= 1 and matrix[3][3] ~= 1 then
        transmap[i][j] = 184
    elseif matrix[1][1] ~= 1 and matrix[3][1] ~= 1 then
        transmap[i][j] = 120
    elseif matrix[1][1] ~= 1 and matrix[1][3] ~= 1 then
        transmap[i][j] = 142
    elseif matrix[3][3] ~= 1 then
        transmap[i][j] = 144
    elseif matrix[3][1] ~= 1 then
        transmap[i][j] = 143
    elseif matrix[1][3] ~= 1 then
        transmap[i][j] = 122
    elseif matrix[1][1] ~= 1 then
        transmap[i][j] = 121
    else
        transmap[i][j] = 166
    end