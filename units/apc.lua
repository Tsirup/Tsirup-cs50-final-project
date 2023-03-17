Apc = Object:extend()

function Apc:new()
    self.cost = 5000
    self.spec = "Apc"
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player.color
    self.move = 6
    self.moveType = "tread"
    self.ready = false
    self.vision = 1
    self.fuel = 70
    self.health = 100
    self.selected = false
    self.movement = nil
    table.insert(UnitList, self)
    Active_Player.money = Active_Player.money - self.cost
end

function Apc:draw()
    local quad
    if self.team == "red" then
        quad = 421
    elseif self.team == "blue" then
        quad = 427
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
end