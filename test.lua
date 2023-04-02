function Heal(unit,default)
    local repairCost = Cost[unit.name] * (default / 100)
    if (ActivePlayer.money / repairCost) < 1 then
        default = default * (ActivePlayer.money / repairCost)
    end
    ActivePlayer.money = ActivePlayer.money - repairCost
    unit.health = unit.health + default
    if unit.health > 100 then
        unit.health = 100
    end
end

Def = .20
Rep = 7000 * Def
Mon = 1000
if Mon / Rep < 1 then
    Def = Def * (Mon / Rep)
    Rep = 70 * Def
end
Mon = Mon - Rep

local digit = math.floor(((math.ceil(0.00001/10) * 10) / 10) + 0.5)

print(digit)
