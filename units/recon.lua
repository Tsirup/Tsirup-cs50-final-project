Recon = Unit:extend()

function Recon:new()
    self.spec = "vehicle"
    self.move = 8
    self.moveType = "tire"
    self.vision = 5
    self.fuel = 80
    self.range = {1}
    Recon.super.new(self)
    if self.team == "red" then
        self.quad = 301
    elseif self.team == "blue" then
        self.quad = 307
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Recon
end