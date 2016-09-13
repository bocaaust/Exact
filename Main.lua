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
    rectMode(CENTER)
    textMode(CENTER)
    turn = 1
    pass = true
    touch = false
    current = card(0,0,0,0)
    symbol = {"♠️","♣️","♥️","♦️"}
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(40, 40, 50)
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
        end
    else
        drawHand(turn)
        fontSize(WIDTH/16)
        text("SCORE: "..score[turn],WIDTH/8*6,HEIGHT*7/8)
        current:draw(WIDTH/2,HEIGHT/2)
    end
    --deck[10]:draw(WIDTH/2,HEIGHT/2)
    -- Do your drawing here
    if turn > players then
        turn = 1
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
