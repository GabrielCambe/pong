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

    love.graphics.printf(
        'Hello World!',
        0, ((VIRTUAL_HEIGHT/2)-6),
        VIRTUAL_WIDTH,
        'center'
    )

    push:finish()
end