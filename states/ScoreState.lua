ScoreState = Class{__includes = BaseState}
 
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:init()
    self.bronzeTrophy = love.graphics.newImage('graphics/Bronze.png')
    self.silverTrophy = love.graphics.newImage('graphics/Silver.png')
    self.goldTrophy = love.graphics.newImage('graphics/Gold.png') 
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
        love.graphics.draw(self.bronzeTrophy, 245, 120, 0, 2, 2)

    elseif self.score >= 6 and self.score <= 10 then
        love.graphics.draw(self.silverTrophy, 245, 120, 0, 2, 2)
        
    elseif self.score >= 11 then
        love.graphics.draw(self.goldTrophy, 245, 120, 0, 2, 2)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end