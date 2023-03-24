Recon = Unit:extend()

function Recon:new()
    self.spec = "vehicle"
    self.move = 8
    self.moveType = "tire"
    self.vision = 5
    self.fuel = 80
    self.range = {1}
    Recon.super.new(self)
    self.quad = 301 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Recon
end