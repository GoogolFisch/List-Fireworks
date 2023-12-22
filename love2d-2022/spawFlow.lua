local fort = {}
fort.__index = fort
local base = setmetatable(fort,{})


function fort.new(x,y,dx,dy,time)
    local self = setmetatable({},{__index = base})
    self.px =  x
    self.py =  y
    self.dx = dx
    self.dy = dy
    self.timer = time
    self.spawn = 0
    return self
end
function fort:tick()
end
function fort:update(dt)
    self.timer = self.timer - dt
    self.spawn = self.spawn + dt
    if self.spawn > 0.0625 then
        self.spawn = 0
        spawnDust(self.px,self.py,0,rand(-220,-180),rand(0.2,0.3),rand(1.3,1.6))
    end
end
function fort:draw()
end
function fort:isDead()
    return self.timer < 0
end

return fort