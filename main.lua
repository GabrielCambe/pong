push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

-- Set up function on the LOVE2D framework
function love.load()
        -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        --     fullscreen = false,
        --     resizable = false,
        --     vsync = true,
        -- })

        love.graphics.setDefaultFilter('nearest', 'nearest')
        
        -- get and set a font object to use in the game
        smallfont = love.graphics.newFont('font.ttf', 8)
        scorefont = love.graphics.newFont('font.ttf', 32)

        push:setupScreen(
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
            WINDOW_WIDTH, WINDOW_HEIGHT,{
            fullscreen = false,
            resizable = false,
            vsync = true,
        })

        player1Score = 0
        player2Score = 0

        player1Y = 30
        player2Y = VIRTUAL_HEIGHT - 50        
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end
    
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end    
end

-- Function called after the u pdate by the LOVE2D framework
function love.draw()
    push:start()
    -- wash the screen with the RGBA color passed as an argument
    love.graphics.clear((40/255), (45/255), (52/255), (255/255))

    love.graphics.setFont(smallfont)
    love.graphics.printf(
        'Hello Pong!',
        0, 20,
        VIRTUAL_WIDTH,
        'center'
    )

    love.graphics.setFont(scorefont)
    love.graphics.print(
        tostring(player1Score),
        VIRTUAL_WIDTH/2 -50, VIRTUAL_HEIGHT/7
    )
    love.graphics.print(
        tostring(player2Score),
        VIRTUAL_WIDTH/2 +30, VIRTUAL_HEIGHT/7
    )
    

    -- the paddles and the ball are rectangles that we draw now and then
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH - 10), player2Y, 5, 20)
    -- the ball
    love.graphics.rectangle('fill', ((VIRTUAL_WIDTH/2)-2), ((VIRTUAL_HEIGHT/2)-2), 4, 4) 

    push:finish()
end