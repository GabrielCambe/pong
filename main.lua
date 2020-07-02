WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Set up function on the LOVE2D framework
function love.load()
        love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
            fullscreen = false,
            resizable = false,
            vsync = true,
        })
end

-- Function called after the update by the LOVE2D framework
function love.draw()
    love.graphics.printf(
        'Hello World!',
        0, ((WINDOW_HEIGHT/2)-6),
        WINDOW_WIDTH,
        'center'
    )
end