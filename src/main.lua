-- main.lua

-- Definições do jogo
local CELL_SIZE = 20 -- Tamanho de cada célula (bloco) em pixels
local BOARD_WIDTH_CELLS = 10 -- Largura do tabuleiro em células
local BOARD_HEIGHT_CELLS = 20 -- Altura do tabuleiro em células

-- Calcula a largura e altura da janela em pixels
local WINDOW_WIDTH_PIXELS = BOARD_WIDTH_CELLS * CELL_SIZE
local WINDOW_HEIGHT_PIXELS = BOARD_HEIGHT_CELLS * CELL_SIZE

local board = {} -- Representa o tabuleiro do jogo (matriz)

-- Cores para as peças (RGBA)
local colors = {
    I = {0, 255, 255, 255}, -- Ciano
    O = {255, 255, 0, 255}, -- Amarelo
    T = {128, 0, 128, 255}, -- Roxo
    S = {0, 255, 0, 255}, -- Verde
    Z = {255, 0, 0, 255}, -- Vermelho
    J = {0, 0, 255, 255}, -- Azul
    L = {255, 165, 0, 255}  -- Laranja
}

-- Formas das peças (matrizes 4x4, 1 para bloco, 0 para vazio)
-- As formas são definidas de forma que a coluna mais à esquerda e a linha mais acima
-- que contenham um bloco '1' sejam consideradas a origem (0,0) da peça.
local shapes = {
    I = {{0,0,0,0}, {1,1,1,1}, {0,0,0,0}, {0,0,0,0}}, -- Peça I horizontal
    O = {{1,1}, {1,1}}, -- Peça O (2x2)
    T = {{0,1,0}, {1,1,1}, {0,0,0}},
    S = {{0,1,1}, {1,1,0}, {0,0,0}},
    Z = {{1,1,0}, {0,1,1}, {0,0,0}},
    J = {{0,0,1}, {1,1,1}, {0,0,0}},
    L = {{1,0,0}, {1,1,1}, {0,0,0}}
}

local currentPiece = nil
local nextPiece = nil
local pieceX, pieceY = 0, 0 -- Posição da peça no tabuleiro (células, 1-based)

local dropTimer = 0
local dropInterval = 0.5 -- Tempo em segundos para a peça cair

-- Função de inicialização do Love2D
function love.load()
    love.window.setTitle("Tetris")
    -- Define o tamanho da janela para encaixar exatamente o tabuleiro
    love.window.setMode(WINDOW_WIDTH_PIXELS, WINDOW_HEIGHT_PIXELS, {resizable = false})

    -- Inicializa o tabuleiro vazio
    for y = 1, BOARD_HEIGHT_CELLS do
        board[y] = {}
        for x = 1, BOARD_WIDTH_CELLS do
            board[y][x] = 0 -- 0 para vazio, cor da peça para preenchido
        end
    end

    -- Gera a primeira peça
    spawnNewPiece()
    nextPiece = getRandomPiece()
end

-- Lógica do jogo
function love.update(dt)
    dropTimer = dropTimer + dt

    if dropTimer >= dropInterval then
        movePiece(0, 1) -- Tenta mover a peça para baixo
        dropTimer = 0
    end
end

-- Função de desenho do Love2D
function love.draw()
    -- Desenha o tabuleiro com os blocos fixos
    for y = 1, BOARD_HEIGHT_CELLS do
        for x = 1, BOARD_WIDTH_CELLS do
            if board[y][x] ~= 0 then
                love.graphics.setColor(board[y][x]) -- Define a cor do bloco fixo
                -- Desenha o bloco fixo na posição de pixel correta
                love.graphics.rectangle("fill", (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
                love.graphics.setColor(0, 0, 0, 255) -- Cor da borda
                love.graphics.rectangle("line", (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
            end
        end
    end

    -- Desenha a peça atual
    if currentPiece then
        local shape = shapes[currentPiece.type]
        local pieceColor = colors[currentPiece.type]
        love.graphics.setColor(pieceColor)

        for sy = 1, #shape do -- sy é a linha dentro da forma da peça
            for sx = 1, #shape[sy] do -- sx é a coluna dentro da forma da peça
                if shape[sy][sx] == 1 then
                    -- Calcula a posição em pixels para o bloco da peça
                    -- pieceX/Y é a origem da peça no tabuleiro (1-based)
                    -- sx/sy é a posição do bloco dentro da forma (1-based)
                    -- O -1 ajusta para coordenadas 0-based para o Love2D
                    local drawX = (pieceX + sx - 1 - 1) * CELL_SIZE -- O primeiro -1 é do sx, o segundo -1 é do pieceX
                    local drawY = (pieceY + sy - 1 - 1) * CELL_SIZE -- O primeiro -1 é do sy, o segundo -1 é do pieceY
                    
                    love.graphics.rectangle("fill", drawX, drawY, CELL_SIZE, CELL_SIZE)
                    love.graphics.setColor(0, 0, 0, 255) -- Cor da borda
                    love.graphics.rectangle("line", drawX, drawY, CELL_SIZE, CELL_SIZE)
                    love.graphics.setColor(pieceColor) -- Volta para a cor da peça
                end
            end
        end
    end

    -- Desenha a grade do tabuleiro
    love.graphics.setColor(50, 50, 50, 255) -- Cor cinza escuro para a grade

    -- Linhas verticais: da borda esquerda (0) até a borda direita (WINDOW_WIDTH_PIXELS)
    for x_pixel = 0, WINDOW_WIDTH_PIXELS, CELL_SIZE do
        love.graphics.line(x_pixel, 0, x_pixel, WINDOW_HEIGHT_PIXELS)
    end
    -- Linhas horizontais: da borda superior (0) até a borda inferior (WINDOW_HEIGHT_PIXELS)
    for y_pixel = 0, WINDOW_HEIGHT_PIXELS, CELL_SIZE do
        love.graphics.line(0, y_pixel, WINDOW_WIDTH_PIXELS, y_pixel)
    end
end

-- Função para lidar com o input do teclado
function love.keypressed(key)
    if key == "left" then
        movePiece(-1, 0)
    elseif key == "right" then
        movePiece(1, 0)
    elseif key == "down" then
        movePiece(0, 1)
        dropTimer = 0 -- Reseta o timer para queda mais rápida
    elseif key == "up" or key == "x" then -- 'up' ou 'x' para girar
        rotatePiece()
    end
end

-- Gera uma nova peça aleatória
function getRandomPiece()
    local pieceTypes = {"I", "J", "L", "O", "S", "T", "Z"}
    local randomIndex = math.random(1, #pieceTypes)
    return {
        type = pieceTypes[randomIndex],
        rotation = 0 -- Rotação inicial
    }
end

-- Spawn de uma nova peça
function spawnNewPiece()
    currentPiece = nextPiece or getRandomPiece()
    nextPiece = getRandomPiece()

    -- Centraliza a peça.
    pieceX = math.floor((BOARD_WIDTH_CELLS - #shapes[currentPiece.type][1]) / 2) + 1
    pieceY = 1 -- Peças começam na linha 1 do tabuleiro (topo)

    -- Game Over: Se a peça já nasce colidindo
    if checkCollision(currentPiece, pieceX, pieceY) then
        love.event.quit()
        print("Game Over!")
    end
end

-- Move a peça
function movePiece(dx, dy)
    local newX = pieceX + dx
    local newY = pieceY + dy

    -- Se a nova posição NÃO CAUSA colisão, move a peça.
    if not checkCollision(currentPiece, newX, newY) then
        pieceX = newX
        pieceY = newY
    else
        -- Se colidiu, e o movimento era para baixo (dy > 0), a peça deve ser fixada.
        if dy > 0 then
            lockPiece()
            clearLines()
            spawnNewPiece()
        end
    end
end

-- Rotaciona a peça
function rotatePiece()
    local originalShape = shapes[currentPiece.type]
    local newShape = {}
    local n = #originalShape -- Assumindo que a peça é quadrada (n x n)

    -- Cria uma nova matriz para a peça rotacionada
    for y = 1, n do
        newShape[y] = {}
        for x = 1, n do
            newShape[y][x] = 0
        end
    end

    -- Lógica de rotação 90 graus no sentido horário
    for y = 1, n do
        for x = 1, n do
            newShape[x][n - y + 1] = originalShape[y][x]
        end
    end

    -- Salva a forma atual para poder restaurar se a rotação colidir e não houver "wall kick"
    local tempOriginalShape = shapes[currentPiece.type]
    shapes[currentPiece.type] = newShape -- Aplica a nova forma temporariamente para checar colisão

    -- Verifica colisão após a rotação
    if checkCollision(currentPiece, pieceX, pieceY) then
        -- Se colidiu, tenta ajustar a posição (simples "wall kick" para o lado)
        -- Tenta mover para a esquerda, depois para a direita
        if not checkCollision(currentPiece, pieceX - 1, pieceY) then
            pieceX = pieceX - 1
        elseif not checkCollision(currentPiece, pieceX + 1, pieceY) then
            pieceX = pieceX + 1
        else
            -- Se nenhuma tentativa de ajuste funcionou, reverte a rotação
            shapes[currentPiece.type] = tempOriginalShape
        end
    end
end

-- Verifica colisão
-- piece: a peça a ser verificada
-- x, y: a possível nova posição (origem) da peça no tabuleiro (1-based)
function checkCollision(piece, x, y)
    local shape = shapes[piece.type]

    for sy = 1, #shape do -- sy é a linha dentro da forma da peça (1-based)
        for sx = 1, #shape[sy] do -- sx é a coluna dentro da forma da peça (1-based)
            if shape[sy][sx] == 1 then -- Se há um bloco nesta parte da forma da peça
                local boardX = x + sx - 1 -- Calcula a coordenada X no tabuleiro (1-based)
                local boardY = y + sy - 1 -- Calcula a coordenada Y no tabuleiro (1-based)

                -- Verifica colisão com as bordas do tabuleiro
                if boardX < 1 or boardX > BOARD_WIDTH_CELLS or boardY > BOARD_HEIGHT_CELLS then
                    return true -- Colidiu com uma borda
                end

                -- Verifica colisão com blocos já fixos no tabuleiro
                -- Apenas verifica se boardY é válido (>= 1) para evitar acessar índices inválidos na matriz 'board'
                if boardY >= 1 and board[boardY][boardX] ~= 0 then
                    return true -- Colidiu com um bloco já existente
                end
            end
        end
    end
    return false -- Nenhuma colisão detectada
end

-- Fixa a peça no tabuleiro
function lockPiece()
    local shape = shapes[currentPiece.type]
    local pieceColor = colors[currentPiece.type]

    for sy = 1, #shape do
        for sx = 1, #shape[sy] do
            if shape[sy][sx] == 1 then
                local boardX = pieceX + sx - 1
                local boardY = pieceY + sy - 1
                -- Garante que só se fixa blocos dentro dos limites válidos do tabuleiro
                if boardY >= 1 and boardY <= BOARD_HEIGHT_CELLS and boardX >= 1 and boardX <= BOARD_WIDTH_CELLS then
                     board[boardY][boardX] = pieceColor
                end
            end
        end
    end
end

-- Remove linhas completas
function clearLines()
    local linesCleared = 0
    for y = BOARD_HEIGHT_CELLS, 1, -1 do -- Itera de baixo para cima
        local lineFull = true
        for x = 1, BOARD_WIDTH_CELLS do
            if board[y][x] == 0 then -- Se algum bloco estiver vazio, a linha não está completa
                lineFull = false
                break
            end
        end

        if lineFull then
            linesCleared = linesCleared + 1
            -- Move todas as linhas acima para baixo
            for moveY = y, 2, -1 do -- Começa da linha atual 'y' e vai subindo
                for x = 1, BOARD_WIDTH_CELLS do
                    board[moveY][x] = board[moveY - 1][x]
                end
            end
            -- Limpa a primeira linha
            for x = 1, BOARD_WIDTH_CELLS do
                board[1][x] = 0
            end
            y = y + 1 -- Reverifica a mesma linha 'y', pois as linhas acima desceram para preenchê-la
        end
    end
    -- TODO Implementar pontuação
end
