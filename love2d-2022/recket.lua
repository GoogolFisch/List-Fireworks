local fart = {}
fart.__index = fart
fart.acc = 50
local base = setmetatable(fart,{})


function fart.new(x,y,dx,dy,time,color)
    local self = setmetatable({},{__index = base})
    self.px =  x
    self.py =  y
    self.dx = dx
    self.dy = dy
    self.ay = fart.acc
    self.ax = 0
    self.color = color
    self.timer = time
    self.lastX = x
    self.lastY = y
    return self
end
function fart:tick()
    spawnDust(self.px,self.py,self.dx,self.dy)
end
function fart:update(dt)
    self.lastX = self.px
    self.lastY = self.py
    self.dx    = self.dx + self.ax * dt
    self.dy    = self.dy + self.ay * dt
    self.px    = self.px  + self.dx * dt
    self.py    = self.py  + self.dy * dt
    self.timer = self.timer - dt
end
function fart:draw()
    love.graphics.setColor(self.color[1],self.color[2],self.color[3])
    love.graphics.line(self.px,self.py,self.lastX,self.lastY)
end
function fart:isDead()
    return self.timer < 0
end

return fart