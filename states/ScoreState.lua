ScoreState = Class{__includes = BaseState}
 
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:load()
    bronzeTrophy = love.graphics.newImage('graphics/Bronze.png')
    silverTrophy = love.graphics.newImage('graphics/Silver.png')
    goldTrophy = love.graphics.newImage('graphics/Gold.png') 
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('OoF! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score >= 0 and self.score <= 5  then
        love.graphics.draw(bronzeTrophy, 245, 120, 0, 2, 2)
    elseif self.score >= 6 and self.score <= 10 then
        love.graphics.draw(silverTrophy, 245, 120, 0, 2, 2)
    elseif self.score >= 11 then
        love.graphics.draw(goldTrophy, 245, 120, 0, 2, 2)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end