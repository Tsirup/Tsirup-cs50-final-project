Battleship = Unit:extend()

function Battleship:new()
    self.name = "Battleship"
    self.order = 20
    self.spec = "ship"
    self.move = 5
    self.moveType = "ship"
    self.vision = 2
    self.fuel = 99
    self.range = {2,3,4,5,6}
    self.damage = {95,90,90,80,55,25,50,80,80,85,85,90,80,nil,nil,nil,nil,nil,nil,50,95,95,95,95,60}
    self.ammo = 9
    Battleship.super.new(self)
    self.quad = 691 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Battleship
end