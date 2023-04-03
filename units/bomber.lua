Bomber = Unit:extend()

function Bomber:new()
    self.name = "Bomber"
    self.order = 15
    self.spec = "plane"
    self.move = 7
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.damage = {110,110,105,105,95,35,90,105,105,105,95,105,105,nil,nil,nil,nil,nil,nil,75,85,95,95,95,75}
    self.ammo = 9
    Bomber.super.new(self)
    self.quad = 601 + (self.teamOrder * 6)
end