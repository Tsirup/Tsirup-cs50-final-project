Mdtank = Unit:extend()

function Mdtank:new()
    self.cost = 16000
    self.spec = "Medium Tank"
    self.move = 5
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {1}
    self.ammo = 8
    Mdtank.super.new(self)
    if self.team == "red" then
        self.quad = 361
    elseif self.team == "blue" then
        self.quad = 367
    end
    table.insert(UnitList, self)
end