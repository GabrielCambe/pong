push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'


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

        love.window.setTitle('Pong')
        
        math.randomseed(os.time())

        -- get and set a font object to use in the game
        smallfont = love.graphics.newFont('font.ttf', 8)
        scorefont = love.graphics.newFont('font.ttf', 32)

        love.graphics.setFont(smallfont)

        push:setupScreen(
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
            WINDOW_WIDTH, WINDOW_HEIGHT,{
            fullscreen = false,
            resizable = false,
            vsync = true,
        })

        player1Score = 0
        player2Score = 0

        player1 = Paddle(10, 30, 5, 20)
        player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

        ball = Ball(VIRTUAL_WIDTH/2 -2, VIRTUAL_HEIGHT/2 -2, 4, 4)

        gameState = 'start'

end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    
    else
        player1.dy = 0
    end


    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end
    
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ball:reset()
        end
    end
end

-- Function called after the u pdate by the LOVE2D framework
function love.draw()
    push:start()
    -- wash the screen with the RGBA color passed as an argument
    love.graphics.clear((40/255), (45/255), (52/255), (255/255))

    love.graphics.setFont(scorefont)
    love.graphics.print(
        tostring(player1Score),
        VIRTUAL_WIDTH/2 -50, VIRTUAL_HEIGHT/7
    )
    love.graphics.print(
        tostring(player2Score),
        VIRTUAL_WIDTH/2 +30, VIRTUAL_HEIGHT/7
    )
    
    love.graphics.setFont(smallfont)
    if gameState == 'start' then
        love.graphics.printf(
            'Start State!',
            0, 20,
            VIRTUAL_WIDTH,
            'center'
        )
    else
        love.graphics.printf(
            'Play State!',
            0, 20,
            VIRTUAL_WIDTH,
            'center'
        )
    end


    -- the paddles and the ball are rectangles that we draw now and then
    player1:render()
    player2:render()
    -- the ball
    ball:render()

    displayFPS()

    push:finish()
end

function displayFPS()
    love.graphics.setFont(smallfont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print(
        'FPS: ' .. tostring(love.timer.getFPS()),
        10, 10
    )
end