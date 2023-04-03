Missles = Unit:extend()

function Missles:new()
    self.name = "Missles"
    self.order = 12
    self.spec = "vehicle"
    self.move = 4
    self.moveType = "tire"
    self.vision = 5
    self.fuel = 50
    self.range = {3,4,5}
    self.damage = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,100,100,120,120,100,120,nil,nil,nil,nil,nil,nil}
    self.ammo = 6
    Missles.super.new(self)
    self.quad = 541 + (self.teamOrder * 6)
end