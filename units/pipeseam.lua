PipeSeam = Object:extend()

function PipeSeam:new(y,x)
    self.x = x
    self.y = y
    self.health = 99
    self.order = 26
    table.insert(UnitList, self)
end
