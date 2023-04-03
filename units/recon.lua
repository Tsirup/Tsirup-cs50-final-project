Recon = Unit:extend()

function Recon:new()
    self.name = "Recon"
    self.order = 3
    self.spec = "vehicle"
    self.move = 8
    self.moveType = "tire"
    self.vision = 5
    self.fuel = 80
    self.range = {1}
    self.damage = {70,65,35,6,1,1,1,45,45,55,4,28,6,nil,nil,12,35,nil,nil,nil,nil,nil,nil,nil,nil}
    Recon.super.new(self)
    self.quad = 301 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Recon
end