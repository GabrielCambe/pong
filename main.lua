push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

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
        love.graphics.setFont(smallfont)

        push:setupScreen(
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
            WINDOW_WIDTH, WINDOW_HEIGHT,{
            fullscreen = false,
            resizable = false,
            vsync = true,
        })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end    
end

-- Function called after the u pdate by the LOVE2D framework
function love.draw()
    push:start()

    -- love.graphics.printf(
    --     'Hello World!',
    --     0, ((WINDOW_HEIGHT/2)-6),
    --     WINDOW_WIDTH,
    --     'center'
    -- )

    -- wash the screen with the RGBA color passed as an argument
    love.graphics.clear((40/255), (45/255), (52/255), (255/255))

    love.graphics.printf(
        'Hello World!',
        0, 20,
        VIRTUAL_WIDTH,
        'center'
    )

    -- the paddles and the ball are rectangles that we draw now and then
    love.graphics.rectangle('fill', 10, 30, 5, 20)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH - 10), (VIRTUAL_HEIGHT - 50), 5, 20)
    -- the ball
    love.graphics.rectangle('fill', ((VIRTUAL_WIDTH/2)-2), ((VIRTUAL_HEIGHT/2)-2), 4, 4) 

    push:finish()
end