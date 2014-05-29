window.NAN = {}

window.NAN.a = 123

class NAN.BackgroundBlock
    constructor: ->
        @id = $.backgroundBlockId
        $.backgroundBlockId += 1
        @x = (1.2 + Math.random()) * $("body").height()
        @y = Math.random() * $("body").width()
        @size = Math.random() * 30 + 20
        $("body").append("<div class='background-block' id='background-block-#{@id}' style='width: #{@size}px; height: #{@size}px'> </div>")
        @getElement().css("-webkit-transform", "rotateZ(#{Math.random() * 360}deg)")
        @getElement().css("background-color", "hsl(#{Math.random() * 360}, 50%, 40%)")

        @update()

    getElement: ()->
        return $("#background-block-#{@id}")

    update: ()->
        @x -= 2
        if @x < -100
            @x = $("body").height()
        @getElement().css("left", "#{@y}px")
        @getElement().css("top", "#{@x}px")
        @getElement().css("z-index", "-10000")

class NAN.Background
    constructor: ->
        @blocks = []
        for i in [0...50]
            @blocks.push(new NAN.BackgroundBlock)
    update: ()->
        for block in @blocks
            block.update()
