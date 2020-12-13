-- author: Colton Ogden

push = require 'lib/push'
Class = require 'lib/class'

require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/CountdownState'
require 'states/ScoreState'

require 'Bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 500

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('graphics/background.png')
local ground = love.graphics.newImage('graphics/ground.png')

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    math.randomseed(os.time())

    -- Loads the font
    mediumFont = love.graphics.newFont('font/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('font/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('font/flappy.ttf', 56)

    -- Loads the sounds
    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/?page=2#comment
        ['music'] = love.audio.newSource("sounds/mario's_way.mp3", 'static')
    }

    -- Loop the music when the end was reached
    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['countdown'] = function() return  CountdownState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title') -- first to appear when the game runs

    love.keyboard.keysPressed  = {}
    love.mouse.mouseButtonPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.mousepressed(x, y, button)
    love.mouse.mouseButtonPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.mouseButtonPressed[button]
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.mouseButtonPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end