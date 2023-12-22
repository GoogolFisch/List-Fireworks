function rand(start,stop)
    return math.random() * (stop - start) + start
end

function love.load()
    _G.logger   = require("logger"  )
    _G.particle = require("part"    )
    _G.recket   = require("recket"  )
    _G.spawReck = require("spawReck")
    _G.spawFlow = require("spawFlow")
    _G.loggit   = logger.init()

    _G.ent = {}
    _G.canvas = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
    _G.timer = 0
    _G.maxVel = 0
    _G.minVel = 0
    love.graphics.setLineWidth(3)
    remap()
end

function remap()
    _G.canvas = love.graphics.newCanvas(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
    _G.maxVel = math.sqrt(0.0008 * _G.recket.acc * love.graphics.getHeight()) * _G.recket.acc
    _G.minVel = math.sqrt(0.0005 * _G.recket.acc * love.graphics.getHeight()) * _G.recket.acc
    print("max:" .. _G.maxVel)
    print("min:" .. _G.minVel)
end

function spawn(bool,x,y,dx,dy)
    rando = math.random()
    posX   = rand(0,love.graphics.getWidth())
    posY   = love.graphics.getHeight()
    deltaX = rand(-50,50)
    deltaY = rand(-_G.maxVel,-_G.minVel)
    if bool ~= nil then
        --x--rand(0,love.graphics.getWidth())
        --dx--rand(-50,50)
        --dy--rand(-270,-200)
        table.insert(_G.ent,recket.new(
            x,y,
            dx,dy,5,{1,1,1}
        ))
    elseif rando > 0.2 then
        table.insert(_G.ent,recket.new(posX,posY,deltaX,deltaY,5,{1,1,1}))
    elseif rando > 0.1 then
        table.insert(_G.ent,recket.new(posX,posY,deltaX,deltaY,5,{1,1,1}))
        table.insert(_G.ent,recket.new(posX,posY,deltaX,deltaY,5,{1,1,1}))
        table.insert(_G.ent,recket.new(posX,posY,deltaX,deltaY,5,{1,1,1}))
    elseif rando > 0.05 then
        table.insert(_G.ent,spawReck.new(posX,posY,deltaX,deltaY,1))
    else
        table.insert(_G.ent,spawFlow.new(posX,posY,deltaX,deltaY,1))
    end
end
function spawnDust(x,y,dx,dy,mulX,mulY)
    mulX = mulX or 1
    mulY = mulY or 1
    color = {1,1,1}
    rando = math.random()
    men = 8
    if     rando < 1 / men then color = {1  ,1  ,0  }
    elseif rando < 2 / men then color = {1  ,0  ,0  }
    elseif rando < 3 / men then color = {0.5,0  ,1  }
    elseif rando < 4 / men then color = {0  ,1  ,1  }
    elseif rando < 5 / men then color = {0.5,1  ,1  }
    elseif rando < 6 / men then color = {0  ,0.5,1  }
    elseif rando < 7 / men then color = {1  ,0  ,0.5}
    elseif rando < 8 / men then color = {0.5,1  ,0.5}
    end
    for w=1,10,1 do
        lx = rand(-50,50) * mulX + dx * 0.25
        ly = rand(-75,25) * mulY + dy * 0.25
        table.insert(_G.ent,_G.particle.new(x,y,lx,ly,5,color))
    end
end

function love.update(dt)
    _G.timer = _G.timer + dt
    for f=#_G.ent,1,-1 do
        _G.ent[f]:update(dt)
        if _G.ent[f]:isDead() then
            _G.ent[f]:tick(_G.ent)
            table.remove(_G.ent,f)
        end
    end
    if _G.timer > 3 then
        _G.timer = 0
        spawn()
    end
    hour = os.date("%H") + 0
    if hour == 0 then
        min  = os.date("%M") + 0

        if min < 2 and _G.timer > 0.5 then
            _G.timer = 0
            spawn()
        elseif min < 4 and _G.timer > 0.75 then
            _G.timer = 0
            spawn()
        elseif min < 8 and _G.timer > 1 then
            _G.timer = 0
            spawn()
        end
    end
end

function renderCanvas(self)
    
    love.graphics.setColor(0,0,0,0.05)
    this = love.graphics.getCanvas()
    love.graphics.rectangle("fill",0,0,this:getWidth(),this:getHeight())

    for f=1,#_G.ent,1 do
        _G.ent[f]:draw()
    end
end

function love.draw()
    _G.canvas:renderTo(renderCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(canvas,0,0,0,1,1)
end

function love.keypressed( key, scancode, isrepeat )
    spawn()
    if love.keyboard.isDown("f11") then
        local fullScreen = love.window.getFullscreen()
        love.window.setFullscreen(fullScreen ~= true)
        remap()
    end
end

function love.resize(w, h)
    remap()
end