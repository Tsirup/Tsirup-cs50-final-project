Battleship = Unit:extend()

function Battleship:new()
    self.spec = "ship"
    self.move = 5
    self.moveType = "ship"
    self.vision = 2
    self.fuel = 99
    self.range = {2,3,4,5,6}
    self.ammo = 9
    Battleship.super.new(self)
    self.quad = 691 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Battleship
end