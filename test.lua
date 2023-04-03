--[[ UnitDmg = {
    {45,50,50,120,"nil","nil",120,75,"nil","nil",65,105,"nil",10,105,1,55,5,25,60,55,75,"nil",120,25},
    {},
    {75,70,75,"nil",40,55,"nil","nil",45,65,"nil",90,55,45,85,15,80,40,70,80,80,"nil",60,"nil",70},
    {25,60,65,65,25,25,"nil","nil",25,55,"nil",75,25,25,75,10,65,20,55,55,65,"nil",25,95,55},
    {85,80,80,"nil",50,95,"nil","nil",60,95,"nil",95,95,55,90,25,90,50,80,90,85,"nil",95,"nil",80},
    {},
    {},
    {95,105,105,"nil",75,95,"nil","nil",75,85,"nil",110,95,95,110,35,105,90,105,105,105,"nil",95,"nil",105},
    {"nil","nil","nil",115,"nil","nil",120,100,"nil","nil",100,"nil","nil","nil","nil","nil","nil","nil","nil","nil","nil",100,"nil",115,"nil"},
    {"nil","nil","nil",115,"nil",25,120,65,5,"nil",55,"nil","nil","nil","nil","nil","nil","nil","nil","nil","nil",100,90,115,"nil"},
    {"nil","nil","nil",100,"nil","nil",120,100,"nil","nil",55,"nil","nil","nil","nil","nil","nil","nil","nil","nil","nil",85,"nil",100,"nil"},
    {5,14,15,7,"nil","nil","nil","nil","nil","nil","nil",55,"nil",1,45,1,26,1,5,12,25,"nil","nil",30,5},
    {},
    {105,105,105,12,10,35,"nil","nil",10,45,"nil",105,35,55,95,25,105,45,85,105,105,"nil",10,45,85},
    {65,75,70,9,"nil","nil","nil","nil","nil","nil","nil",65,"nil",15,55,5,85,15,55,85,85,"nil","nil",35,55},
    {195,195,195,22,45,105,"nil","nil",45,65,"nil",135,75,125,125,65,195,115,180,195,195,"nil",45,55,180},
    {"nil","nil","nil",120,"nil","nil",120,100,"nil","nil",100,"nil","nil","nil","nil","nil","nil","nil","nil","nil","nil",100,"nil",120,"nil"},
    {115,125,115,22,15,40,"nil","nil",15,50,"nil",125,50,75,115,35,125,55,105,125,125,"nil",15,55,105},
    {85,80,80,105,55,60,120,75,60,85,65,95,60,55,90,25,90,50,80,90,85,75,85,105,80},
    {4,45,45,12,"nil","nil","nil","nil","nil","nil","nil",70,"nil",1,65,1,28,1,6,35,55,"nil","nil",35,6},
    {85,80,80,"nil",55,60,"nil","nil",60,85,"nil",95,60,55,90,25,90,50,80,90,85,"nil",85,"nil",80},
    {50,85,75,85,45,65,120,70,45,35,45,90,65,70,90,15,85,60,80,85,85,55,55,95,75},
    {"nil","nil","nil","nil",55,95,"nil","nil",75,25,"nil","nil",95,"nil","nil","nil","nil","nil","nil","nil","nil","nil",55,"nil","nil"},
    {},
    {65,75,70,10,1,10,"nil","nil",1,5,"nil",75,10,15,70,10,85,15,55,85,85,"nil",1,40,55}}

for _, unit in ipairs(UnitDmg) do
    local newDmg = {}
    table.insert(newDmg,unit[12])
    table.insert(newDmg,unit[15])
    table.insert(newDmg,unit[20])
    table.insert(newDmg,unit[25])
    table.insert(newDmg,unit[14])
    table.insert(newDmg,unit[16])
    table.insert(newDmg,unit[18])
    table.insert(newDmg,unit[2])
    table.insert(newDmg,unit[3])
    table.insert(newDmg,unit[21])
    table.insert(newDmg,unit[1])
    table.insert(newDmg,unit[17])
    table.insert(newDmg,unit[19])
    table.insert(newDmg,unit[11])
    table.insert(newDmg,unit[8])
    table.insert(newDmg,unit[4])
    table.insert(newDmg,unit[24])
    table.insert(newDmg,unit[22])
    table.insert(newDmg,unit[7])
    table.insert(newDmg,unit[5])
    table.insert(newDmg,unit[10])
    table.insert(newDmg,unit[13])
    table.insert(newDmg,unit[23])
    table.insert(newDmg,unit[6])
    table.insert(newDmg,unit[9])
    local concatDmg = table.concat(newDmg, ",")
    print(concatDmg)
end ]]

Dmg = {
{105,105,60,25,10,1,5,50,50,55,45,55,25,65,75,120,120,75,120,nil,nil,nil,nil,nil,nil},
{},
{90,85,80,70,45,15,40,70,75,80,75,80,70,nil,nil,nil,nil,nil,nil,40,65,55,60,55,45},
{75,75,55,55,25,10,20,60,65,65,25,65,55,nil,nil,65,95,nil,nil,25,55,25,25,25,25},
{95,90,90,80,55,25,50,80,80,85,85,90,80,nil,nil,nil,nil,nil,nil,50,95,95,95,95,60},
{},
{},
{110,110,105,105,95,35,90,105,105,105,95,105,105,nil,nil,nil,nil,nil,nil,75,85,95,95,95,75},
{nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,100,100,115,115,100,120,nil,nil,nil,nil,nil,nil},
{nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,55,65,115,115,100,120,nil,nil,nil,90,25,5},
{nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,55,100,100,100,85,120,nil,nil,nil,nil,nil,nil},
{55,45,12,5,1,1,1,14,15,25,5,26,5,nil,nil,7,30,nil,nil,nil,nil,nil,nil,nil,nil},
{},
{105,95,105,85,55,25,45,105,105,105,105,105,85,nil,nil,12,45,nil,nil,10,45,35,10,35,10},
{65,55,85,55,15,5,15,75,70,85,65,85,55,nil,nil,9,35,nil,nil,nil,nil,nil,nil,nil,nil},
{135,125,195,180,125,65,115,195,195,195,195,195,180,nil,nil,22,55,nil,nil,45,65,75,45,105,45},
{nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,100,100,120,120,100,120,nil,nil,nil,nil,nil,nil},
{125,115,125,105,75,35,55,125,115,125,115,125,105,nil,nil,22,55,nil,nil,15,50,50,15,40,15},
{95,90,90,80,55,25,50,80,80,85,85,90,80,65,75,105,105,75,120,55,85,60,85,60,60},
{70,65,35,6,1,1,1,45,45,55,4,28,6,nil,nil,12,35,nil,nil,nil,nil,nil,nil,nil,nil},
{95,90,90,80,55,25,50,80,80,85,85,90,80,nil,nil,nil,nil,nil,nil,55,85,60,85,60,60},
{90,90,85,75,70,15,60,85,75,85,50,85,80,45,70,85,95,55,120,45,35,65,55,65,45},
{nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,55,25,95,55,95,75},
{},
{75,70,85,55,15,10,15,75,70,85,65,85,55,nil,nil,10,40,nil,nil,1,5,10,1,10,1}}

for _,d in ipairs(Dmg) do
    print(#d)
end