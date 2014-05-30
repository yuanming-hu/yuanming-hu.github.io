@hsvString = (h, s, v) ->
    color = hsvToRgb(h, s, v);
    return colorToString([Math.floor(color[0]), Math.floor(color[1]), Math.floor(color[2])])


@randomColor = ->
    color = hsvToRgb(Math.random() * 0.1 + 0.4, 0.8, 0.9);
    return [Math.floor(color[0]), Math.floor(color[1]), Math.floor(color[2])]

@colorToString = (color) ->
    return "rgb(#{color[0]}, #{color[1]}, #{color[2]})"


@randomColorString = ->
    color = randomColor()
    return colorToString(color)

@clamp = (a) ->
    return Math.max(Math.min(a, 1.0), 0.0) 

@mediate = (left, right, rate)->
    return left + (right - left) * rate

@colorToString = (color)->
    return "hsl(#{(color.h - Math.floor(color.h)) * 360}, #{clamp(color.s) * 100}%, #{clamp(color.l) * 100}%)"


@getTime = ()->
    date = new Date()
    return date.getTime() 


class NAN.Grid 
    constructor: (@x, @y, @game, show)->
        @mouse = @game.mouse
        @id = @game.gridId
        @deltaX = 0
        @game.gridId += 1
        @exist = true
        @value = Math.floor(Math.random() * 10)
        @selected = false

        @width = $.game.gridWidth
        @height = $.game.gridHeight
        @color = @getColor() 
        @remainedTime = -1
        $("#game-area").append("<div class='square' id='square-#{@id}'></div>")
        @position = @getPosition()
        @getElement().css("background-color", colorToString(@color))
        @getElement().append("<div class='number'>#{@value}</div>")
        @getElement().css("opacity", 0)
        @show() if show
        @getElement().mouseover(
            =>
                @mouseOver()
                return false;
        )
        @getElement().mousedown(
            =>
                @mouseDown()
                return false;
        )
        @getElement().mouseup(
            =>
                @mouseUp()
                return false;
        )
        @update()

    cleaned: ()->
        return @remainedTime >= 0

    clean: ()-> 
        @remainedTime = 30

    moveTo: (x, y)-> 
        @x = x
        @y = y

    testInside: (x, y)->
        return @position.x <= x and x <= @position.x + @height and @position.y <= y and y <= @position.y + @width
        
    getColor: ()->
        color = {}
        color.h = 0.35 + @value * 0.000
        if @selected
            color.s = 0.6
            color.l = 0.9
        else
            color.s = 0.54
            color.l = 0.7
        return color 

    getPosition: ()->
        originPosition = {x: @game.gridXOffset + @x * @game.gridHeight, y: @game.gridYOffset + @y * @game.gridWidth}
        if @cleaned()
            rate = 0.5 + -Math.cos(Math.PI * (30 - @remainedTime) / 30) / 2
            x = mediate(originPosition.x, @game.score.position.x, rate)
            y = mediate(originPosition.y, @game.score.position.y - @game.gridWidth / 2, rate)
            return {x: x, y: y}

        return originPosition

    getElement: () ->
        return $("#square-#{@id}")

    isConnecting: (grid) ->
        neighbouring = (Math.abs(grid.x - @x) + Math.abs(grid.y - @y) == 1)
        return neighbouring

    show: ()->
        @getElement().show(0)
        @getElement().animate({opacity: 1.0}, 400)

    update: ->
        if @cleaned()
            if @remainedTime == 0
                @exist = false
            @getElement().css("opacity", Math.pow(@remainedTime / 30, 3))

            @remainedTime -= 1

        @color = @getColor()
        if @deltaX != 0
            movement = Math.min(@deltaX, 10)
            @deltaX -= movement
            @position.x += movement
        if @cleaned()
            @position = @getPosition()
        if @position != @lastPosition
            @getElement().css("top", "#{@position.x}px")
            @getElement().css("left", "#{@position.y}px")
        @lastPosition = {x:@position.x, y:@position.y}

        if @color != @lastColor
            @getElement().css("background-color", colorToString(@color))
        @lastColor = @color

    mouseDown: ()->
        if @mouse.state == "none"
            @mouse.beginPath()
            @mouse.addGrid(this)

    makeSound: ()->
        $.audioPlayerA.play(@value, 0.3)


    mouseOver: ()->
        if @mouse.state == "select"
            @mouse.addGrid(this)

    mouseUp: ()->
        if @mouse.state == "select"
            @mouse.endPath()
