-- Exact
displayMode(FULLSCREEN)
supportedOrientations(LANDSCAPE_ANY)
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    deck = {}
    deckPopulate()
    players = 2
    hands= {}
    for i =1,players do
        hands[i] = {}
    end
    fillHands()
    rectMode(CENTER)
    textMode(CENTER)
    turn = 1
    symbol = {"♠️","♣️","♥️","♦️"}
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    -- This sets the line thickness
    
    --deck[10]:draw(WIDTH/2,HEIGHT/2)
    -- Do your drawing here
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
    end
end

card = class()

function card:init(star,cube,sphere,cone)
    if star + cube + sphere + cone <= 12 and star + cube + sphere + cone >= 4 then
        self.value = {star,cube,sphere,cone}
        end
    self.selected = 0
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
    if self.selected >0 then
        stroke(173, 220, 222, 171)
    end
    rect(x,y,WIDTH/30,HEIGHT/12)
    fill(224, 224, 218, 211)
    rect(x,y,WIDTH/12-7,HEIGHT/6-7)
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
end
