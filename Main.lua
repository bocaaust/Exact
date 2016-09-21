-- Exact
displayMode(FULLSCREEN)
supportedOrientations(LANDSCAPE_ANY)
-- Use this function to perform your initial setup
function setup()
    deck = {}
    score={}
    for i = 1,3 do
        score[i] = {}
    end
    touch2 = false
    
    spriteMode(CENTER)
    positions = {0,0}
    tags = {"PILES: ","BID: ","SCORE: "}
    isMoving = true
    rectMode(CENTER)
    textMode(CENTER)
    pass = true
    touch = false
    totals = {}
    hasThrown = {}
    null = current
    symbol = {"♠️","♣️","♥️","♦️"}
    cPlay = true
    hasSetup = false
    drawingLeaderboard = false
    leaderboard = {}
end

function postSetup()
    deckPopulate()
    hands= {}
    score[2] = {}
    fillHands()
    hasSetup = true
    face = 0
    current = card(0,0,0,0)
    bSum = 0
    --bids = {}
    lastPlayer = 0
    turn = 1
    drawingLeaderboard=false
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(65, 101, 59, 255)
    -- This sets the line thickness
    if drawingLeaderboard then
        fontSize(WIDTH/7)
        fill(0)
        text("🔚",WIDTH/8,HEIGHT/2)
        text("⚔",WIDTH*3.5/4,HEIGHT/2)
        fontSize(WIDTH/24)
        text("Next Round",WIDTH*3.5/4,1.4*HEIGHT/4)
        fill(math.random(0,25))
        text("LEADERBOARD",WIDTH/2,HEIGHT*7/8)
        fill(0)
        fontSize(WIDTH/30)
        for i=1,#leaderboard do
            text(leaderboard[i],WIDTH/2,HEIGHT*6/8-(i-1)*HEIGHT*5/(8*players))
        end
        if CurrentTouch.state == BEGAN then
            touch = true
        end
        if CurrentTouch.state == ENDED and touch then
            if CurrentTouch.x > WIDTH/2 then
                postSetup()
            else
                setup()
            end
        end
    else
        if hasSetup then
            
            if pass then
                fill(255, 255, 255, 255)
                --fontSize(WIDTH/6)
                -- text("Pass To Next Player",WIDTH/2,HEIGHT/4*3)
                fontSize(WIDTH/9)
                text("Tap to Continue",WIDTH/2,HEIGHT/2)
                if CurrentTouch.state == BEGAN then
                    touch = true
                end
                if touch and CurrentTouch.state == ENDED then
                    pass = false
                    touch = false
                    touch2 = false
                end
            else
                if CurrentTouch.state == ENDED then
                    touch = true
                end
                if #score[2] == players then
                    drawHand(turn)
                    current:draw(WIDTH/2,HEIGHT/2)
                    drawButtons()
                    fontSize(WIDTH/45)
                    
                    fill(0)
                    if face == 0 then
                        if touch and CurrentTouch.state == BEGAN then
                            readButtons()
                        end
                        
                        text("Tap a suit to call",WIDTH/2,HEIGHT/4*3)
                    else
                        
                        if cPlay then
                            
                            if current.sum == 0 then
                                text("Tap a card to start with",WIDTH/2,HEIGHT/4*3)
                                if touch and readCard() > 0 then
                                    current = table.remove(hands[turn],readCard())
                                    lastPlayer = turn
                                    nextTurn()
                                end
                            else
                                text("Tap a card that has a sum equal to or higher than the last played card with a matching suit",WIDTH/2,HEIGHT/4*3)
                                if touch and readCard() > 0 then
                                    if checkCard(hands[turn][readCard()]) then
                                        current = table.remove(hands[turn],readCard())
                                        lastPlayer = turn
                                        nextTurn()
                                    end
                                end
                            end
                        else
                            if endGame() then
                                --Score tallying and prompt to continue here
                                checkScores()
                                drawingLeaderboard = true
                                touch = false
                                rankPlayers()
                            else
                                text("Tap a card to discard or tap ✖️ to continue",WIDTH/2,HEIGHT/4*3)
                                fontSize(WIDTH/12)
                                text("✖️",WIDTH/2,HEIGHT/2)
                                if CurrentTouch.y> HEIGHT*7/16 then
                                    if touch then
                                        hasThrown[turn] = true
                                        nextTurn()
                                        while hasThrown[turn] and turn ~= lastPlayer do
                                            nextTurn()
                                        end
                                        if turn == lastPlayer then
                                            nextStack()
                                        end
                                    end
                                else
                                    if touch and readCard() > 0 then
                                        table.remove(hands[turn],readCard())
                                        nextTurn()
                                        hasThrown[turn] = true
                                        while hasThrown[turn] and turn ~= lastPlayer do
                                            nextTurn()
                                        end
                                        if turn == lastPlayer then
                                            nextStack()
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    fontSize(WIDTH/20)
                    --more efficient version
                    h = HEIGHT*.875
                    for i = 1,3 do
                        text(tags[i]..score[i][turn],WIDTH*.75,h)
                        x,y = textSize(tags[i]..score[i][turn])
                        h = h - y
                    end
                else
                    --bidding section here
                    -- if (bSum > 0 and bSum < 8) or (bSum == 8 and) then
                    x = WIDTH/4+WIDTH/18
                    --   else
                    --  x = WIDTH/4
                    if CurrentTouch.state == BEGAN then
                        touch2 = true
                    end
                    fontSize(WIDTH/18)
                    --  print(#score[2]+1)
                    text("Player "..(#score[2]+1).." bet on the number of tricks you'll get",WIDTH/2,HEIGHT/4*3)
                    for i=0,8 do
                        if bSum +i ~= 8 then
                            text(i,x,HEIGHT/2)
                            x = x + WIDTH/18
                            if CurrentTouch.state == ENDED and touch2 and CurrentTouch.x >x-WIDTH/18 and CurrentTouch.x<x+WIDTH/32-WIDTH/18 then
                                score[2][(#score[2]+1)] = i
                                bSum = bSum + i
                                pass = true
                                touch = false
                                touch2 = false
                            end
                        end
                    end
                end
            end
        else
            fill(255)
            fontSize(WIDTH/32)
            text("Select the number of players",WIDTH/2,HEIGHT*3/4)
            --if CurrentTouch.state == ENDED then
            touch = true
            --end
            
            fontSize(WIDTH/12)
            for i = 2,8 do
                if touch then
                    if CurrentTouch.state == ENDED then
                        if CurrentTouch.x > (i-.5)*WIDTH/9-textSize(i) and CurrentTouch.x < (i-.5)*WIDTH/9+textSize(i) then
                            players = i
                            touch = false
                            hasSetup = true
                            postSetup()
                            touch = false
                            
                        end
                        
                        
                    end
                end
                text(i,(i-.5)*WIDTH/9,HEIGHT/2)
            end
        end
    end
end

function rankPlayers()
    leaderboard = {}
    temp = score[3]
    temp2 = temp
    table.sort(temp2)
    for i=1,#temp2 do
        for j=1,players do
            if temp2[i] == temp[j] then
                table.insert(leaderboard,"Player "..j..": "..temp2[i].." Points")
                break
            end
        end
    end
end


function checkScores()
    --pbs
    for i = 1,players do
        if #hands[i] > 0 then
            score[1][i] = score[1][i] + #hands[i]
        end
        if score[1][i] == score[2][i] then
            score[3][i] = score[3][i] + score[1][i]
        elseif score[1][i] < score[2][i] then
            score[3][i] = score[3][i] - (score[2][i]-score[1][i])
        else
            score[3][i] = score[3][i] - (score[1][i]-score[2][i])
        end
    end
end

function endGame()
    hasCards = 0
    for i = 1,players do
        if #hands[i] > 0 then
            hasCards = hasCards + 1
        end
    end
    return (hasCards <= 1)
end

function readCard()
    if CurrentTouch.y < HEIGHT/2 then
        x = WIDTH/(1+#hands[turn])
        n = x
        x = x - WIDTH/24
        for i =1,#hands[turn] do
            if CurrentTouch.x > x and CurrentTouch.x < x+n then
                return i
            end
            x = x + n
        end
    end
    return 0
end

function canPlay()
    if endGame() then
        return false
    else
        if #hands[turn] > 0 then
            for i=1,#hands[turn] do
                if checkCard(hands[turn][i]) == true then
                    return true
                end
            end
            return false
        else
            return false
            
        end
    end
end




function checkCard(input)
    return (input.value[face] == current.value[face] and input.sum >= current.sum)
end
function nextStack()
    face = 0
    current = null
    score[1][lastPlayer] = score[1][lastPlayer] + 1
    turn = lastPlayer
    cPlay = true
    hasThrown = {}
    for i =1,players do
        hasThrown[i] = false
    end
end


function drawButtons()
    fontSize(WIDTH/12)
    fill(77, 46, 70, 255)
    rect(WIDTH/8,HEIGHT*3/4-HEIGHT/24,WIDTH/4,HEIGHT/4*2+HEIGHT/12)
    for i=1,4 do
        if face == i then
            fill(255, 0, 0, 122)
            rect(WIDTH/8,HEIGHT/2.5+i*HEIGHT/8,WIDTH/4,HEIGHT/12)
            if current:cone() > 0 then
                fill(255)
                text(current.value[i],WIDTH/8+WIDTH/16,HEIGHT/2.5+i*HEIGHT/8)
            end
        end
        
        fill(255, 255, 255, 255)
        text(symbol[i],WIDTH/8+i,HEIGHT/2.5+i*HEIGHT/8)
    end
end
function readButtons()
    for i = 1,4 do
        if CurrentTouch.y > HEIGHT/2.5 +(i)*HEIGHT/8-HEIGHT/24 and CurrentTouch.y < HEIGHT/2.5 +(i)*HEIGHT/8+HEIGHT/24  then
            face = i
            --  print("selected i")
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
    deck = {}
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
    hasThrown = {}
    for i = 1,players do
        hands[i] = {}
        if score[3][i] == nil then
            score[3][i] = 0
        end
        hasThrown[i] = false
        for h=1,8 do
            hands[i][h] = table.remove(deck,1)
        end
        score[1][i] = 0
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
    cPlay = canPlay()
    pass = true
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
