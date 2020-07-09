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
        largefont = love.graphics.newFont('font.ttf', 16)
        scorefont = love.graphics.newFont('font.ttf', 32)
        titlefont = love.graphics.newFont('font.ttf', 64)
        
        love.graphics.setFont(smallfont)

        sounds = {
            ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
            ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
            ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
            ['selection'] = love.audio.newSource('sounds/selection.wav', 'static')
        }

        push:setupScreen(
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
            WINDOW_WIDTH, WINDOW_HEIGHT,{
            fullscreen = false,
            resizable = true,
            vsync = true,
        })

        player1Score = 0
        player2Score = 0

        servingPlayer = math.random( 2 )

        player1 = Paddle(10, 30, 5, 20)
        player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
        ball = Ball(VIRTUAL_WIDTH/2 -2, VIRTUAL_HEIGHT/2 -2, 4, 4)

        AIplaying = false
        selectionState = '1Player'        
        gameState = 'menu'
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            
            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)            
            end

            sounds.paddle_hit:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
            
            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)            
            end
        
            sounds.paddle_hit:play()        
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds.wall_hit:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds.wall_hit:play()
        end


        if ball.x < 0 then
            sounds.score:play()
            
            servingPlayer = 1
            player2Score = player2Score + 1
        
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
    
            end
        end
    
        if ball.x > VIRTUAL_WIDTH then
            sounds.score:play()

            servingPlayer = 2
            player1Score = player1Score + 1
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end       
    end



    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED  
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if AIplaying == true and gameState == 'play' then 
        if math.abs(ball.y - player2.y) >= 3 then
            player2.dy = ((ball.y - player2.y)/math.abs(ball.y - player2.y)) * PADDLE_SPEED
        else
            player2.dy = 0
        end
    end

    if love.keyboard.isDown('up') and not AIplaying then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') and not AIplaying then
        player2.dy = PADDLE_SPEED
    elseif not AIplaying then
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
        if gameState == 'menu' then
            if selectionState == '1Player' then
                AIplaying = true
            else
                AIplaying = false
            end
            gameState = 'start'    
        elseif gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end        
    elseif key == 'w' or key == 'up' or key == 's' or key == 'down' then
        if gameState == 'menu' then
            if selectionState == '1Player' then
                selectionState = '2Players'
            else
                selectionState = '1Player'
            end
            sounds.selection:play()
        end
 
    end
end

-- Function called after the u pdate by the LOVE2D framework
function love.draw()
    push:start()
    -- wash the screen with the RGBA color passed as an argument
    love.graphics.clear((40/255), (45/255), (52/255), (255/255))
    
    if gameState == 'menu' then
        love.graphics.setFont(titlefont)
        love.graphics.printf(
            "PONG!",
            0, VIRTUAL_HEIGHT/4,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.setFont(largefont)
        
        love.graphics.printf(
            "1 Player",
            0, VIRTUAL_HEIGHT/4 + 74,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf(
            "2 Players",
            0, VIRTUAL_HEIGHT/4 + 94,
            VIRTUAL_WIDTH,
            'center'
        )

        if selectionState == '1Player' then
            love.graphics.rectangle(
                'line',
                VIRTUAL_WIDTH/2 - 48, VIRTUAL_HEIGHT/4 + 74,
                96, 18
            )
        else
            love.graphics.rectangle(
                'line',
                VIRTUAL_WIDTH/2 - 48, VIRTUAL_HEIGHT/4 + 94,
                96, 18
            
            )
        end

    elseif gameState == 'start' then
        love.graphics.setFont(smallfont)
        love.graphics.printf(
            "Let's play PONG!",
            0, 10,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf(
            'Press ENTER to begin.',
            0, 20,
            VIRTUAL_WIDTH,
            'center'
        )        
    elseif gameState == 'serve' then
        love.graphics.setFont(smallfont)
        love.graphics.printf(
            'Player ' .. tostring(servingPlayer).. "'s serve!",
            0, 10, VIRTUAL_WIDTH, 'center'
        )
        love.graphics.printf(
            'Press ENTER to serve.',
            0, 20, VIRTUAL_WIDTH, 'center'
        )
    elseif gameState == 'play' then
    elseif gameState == 'done' then
        love.graphics.setFont(largefont)
        love.graphics.printf(
            'Player ' .. tostring(servingPlayer).. " wins!",
            0, 10, VIRTUAL_WIDTH, 'center'
        )
        love.graphics.printf(
            'Press ENTER to restart.',
            0, 30, VIRTUAL_WIDTH, 'center'
        )
    end

    if gameState ~= 'menu' then
        player1:render()
        player2:render()
        ball:render()
        displayScore()

    end

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

function displayScore()
    love.graphics.setFont(scorefont)
    love.graphics.print(
        tostring(player1Score),
        VIRTUAL_WIDTH/2 -50, VIRTUAL_HEIGHT/7
    )
    love.graphics.print(
        tostring(player2Score),
        VIRTUAL_WIDTH/2 +30, VIRTUAL_HEIGHT/7
    )    
end