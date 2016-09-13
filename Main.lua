-- Exact
displayMode(FULLSCREEN)
supportedOrientations(LANDSCAPE_ANY)
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    deck = {}
    score={}
    deckPopulate()
    spriteMode(CENTER)
    players = 2
    hands= {}
    for i =1,players do
        hands[i] = {}
    end
    fillHands()
    positions = {0,0}
    rectMode(CENTER)
    textMode(CENTER)
    turn = 1
    pass = true
    touch = false
    face = 0
    current = card(0,0,0,0)
    null = current
    lastPlayer = 0
    symbol = {"♠️","♣️","♥️","♦️"}
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(65, 101, 59, 255)
    -- This sets the line thickness
    
    if pass then
        fill(255, 255, 255, 255)
        --fontSize(WIDTH/6)
        -- text("Pass To Next Player",WIDTH/2,HEIGHT/4*3)
        fontSize(WIDTH/9)
        text("Tap to Continue",WIDTH/2,HEIGHT/2)
        if CurrentTouch.state == ENDED then
            touch = true
        end
        if touch then
            pass = (CurrentTouch.state == BEGAN)
            touch = false
        end
    else
        drawHand(turn)
        drawButtons()
        if CurrentTouch.state == BEGAN then
            touch = true
        end
        if face == 0 then
            if touch then
                readButtons()
            end
            fontSize(WIDTH/45)
            fill(0)
            text("Tap a card to start with and select a suit to call",WIDTH/2,HEIGHT/4*3)
        end
        
        fontSize(WIDTH/16)
        text("SCORE: "..score[turn],WIDTH/8*6,HEIGHT*7/8)
        current:draw(WIDTH/2,HEIGHT/2)
    end
    --deck[10]:draw(WIDTH/2,HEIGHT/2)
    -- Do your drawing here
    
end
function nextStack()
    face = 0
    current = null
    score[lastPlayer] = score[lastPlayer] + 1
    turn = lastPlayer
end
function drawButtons()
    fontSize(WIDTH/12)
    fill(77, 46, 70, 255)
    rect(WIDTH/8,HEIGHT*3/4-HEIGHT/24,WIDTH/4,HEIGHT/4*2+HEIGHT/12)
    for i=1,4 do
        if face == i then
            fill(255, 0, 0, 122)
            rect(WIDTH/8+i,HEIGHT/2.5+i*HEIGHT/8,WIDTH/4,HEIGHT/12)
        end
        
        fill(255, 255, 255, 255)
        text(symbol[i],WIDTH/8+i,HEIGHT/2.5+i*HEIGHT/8)
    end
end
function readButtons()
    for i = 1,4 do
        if CurrentTouch.y > HEIGHT/2.5 +(i)*HEIGHT/8-HEIGHT/24 and CurrentTouch.y < HEIGHT/2.5 +(i)*HEIGHT/8+HEIGHT/24  then
            face = i
            print("selected i")
        end
    end
end
function drawHand(t)
    x = WIDTH/(1+#hands[t])
    n = x
    for i =1,#hands[t] do
        hands[t][i]:draw(x,HEIGHT/4)
        x = x + n
    end
end

function deckPopulate()
    c=1
    for x =1,3 do
        for y = 1,3 do
            for z=1,3 do
                for w=1,3 do
                    if #deck == 0 then
                        deck[1]=card(x,y,z,w)
                    else
                        table.insert(deck,math.random(1,#deck),card(x,y,z,w))
                    end
                end
            end
        end
    end
end

function fillHands()
    for i = 1,players do
        for h=1,8 do
            hands[i][h] = table.remove(deck,1)
        end
        score[i] = 0
    end
end

card = class()

function card:init(star,cube,sphere,cone)
    --if star + cube + sphere + cone <= 12 and star + cube + sphere + cone >= 4 then
    self.value = {star,cube,sphere,cone}
    -- end
    self.sum = star + cube + sphere + cone
    self.selected = false
    self.flip = true
end
function card:star()
    return self.value[1]
end
function card:star()
    return self.value[2]
end
function card:sphere()
    return self.value[3]
end

function nextTurn()
    turn = turn + 1
    if turn > players then
        turn = 1
    end
end

function card:cone()
    return self.value[4]
end
function card:draw(x,y)
    strokeWidth(5)
    stroke(255)
    fontSize(WIDTH/30/4)
    fill(255, 255, 255, 255)
    if self.selected then
        stroke(173, 220, 222, 171)
        x = position[1]
        y = position[2]
    end
    rect(x,y,WIDTH/30,HEIGHT/12)
    fill(224, 224, 218, 211)
    rect(x,y,WIDTH/12-7,HEIGHT/6-7)
    
    if self.flip or self.sum > 0 then
        local i = x - WIDTH/30 + 11
        local z = y - HEIGHT/6/4
        for f = 1,4 do
            if self.value[f] > 0 then
                local temp = z
                for d =1,self.value[f] do
                    text(symbol[f],i,temp)
                    temp = temp + HEIGHT/6/4
                end
            end
            i = i + WIDTH/30/4+7
        end
    else
        tint(255, 255, 255, 155)
        sprite("Project:cardBack",x,y,WIDTH/12-7,HEIGHT/6-7)
    end
    fill(0)
    text(self.sum,x+WIDTH/24-15,y+HEIGHT/6/2-15)
end
