TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Bird', 0, 64, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter: Play', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press p: Pause', 0, 120, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press escape: Quit', 0, 140, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Mario's way by xsgianni", 0, 250, VIRTUAL_WIDTH, 'center')
end