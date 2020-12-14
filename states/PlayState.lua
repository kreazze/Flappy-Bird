--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu
    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    self.pipeInterval = math.random(2, 3) == 2 and 3 or 2

    ScoreState:load()
end

function PlayState:update(dt)
    if scrolling then

        -- update timer for pipe spawning
        self.timer = self.timer + dt

        -- spawn pipe with random interval either 2 or 3 seconds long
        if self.timer > self.pipeInterval then
            self.pipeInterval = math.random(2, 3) == 2 and 3 or 2

            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y

            -- resets timer
            self.timer = 0

            -- add new pipe pair at the end of the screen
            table.insert(self.pipePairs, PipePair(y))
        end

        -- for every pair of pipes
        for k, pair in pairs(self.pipePairs) do
            -- score a point if the pipe has gone past the bird to the left all the way
            -- be sure to ignore it if it's already been scored
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then
                    sounds['score']:play()
                    self.score = self.score + 1
                    pair.scored = true
                end
            end

            -- update position of pair
            pair:update(dt)
        end

        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

        -- simple collision between pipes and bird
        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['hit']:play()
                    sounds['explosion']:play()
                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end

        -- update bird based on gravity and input
        self.bird:update(dt)

        if not self.bird:aboveGround() then
            sounds['hit']:play()
            sounds['explosion']:play()
            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    if love.keyboard.wasPressed('p') then
        if scrolling then
            scrolling = false
            sounds['music']:pause()
        else
            scrolling = true
            sounds['music']:play()
        end
    end
end

function PlayState:render() 
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    
    self.bird:render()

    if not scrolling then
        love.graphics.printf('Paused', 0, 110, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press p to resume', 0, 140, VIRTUAL_WIDTH, 'center')
    end
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end