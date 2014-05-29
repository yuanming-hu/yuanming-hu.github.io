class NAN.Score
    constructor: ->
        @value = 0
        @displayedValue = 0
        @position = {x: 20, y: $("#container").width() / 2}

    addValue: (points)->
        @value += points

    update: ->
        delta = (@value - @displayedValue) * 0.1
        @displayedValue += delta
        $(".score").html("#{Math.floor(@displayedValue + 0.3)}")

class NAN.NumberShow
    constructor: (data)->
        @getElementAjax().hide(0)
        @totalFrames = 50
        @time = 0
        @finished = false
        @clicked = false
        @getElement().show()
        setStyleRuleValue(".number", "visibility", "hidden")
        @getElement().animate({opacity: "0.70"}, 200)
        @getElementNumber().html(data.n)
        @getElementScore().html(data.score.toString() + " points")
        if data.descriptions == null or data.descriptions == ""
            data.descriptions = "平凡的数"
        else
            @queryServer(data.n)
        @getElementDescriptions().html(data.descriptions)

        @getElement().click(
            =>
                @onClick()
        )
        @getElement().on(
            "touchstart",
            =>
                @onClick()
        )
        @getElement().on(
            "touchmove",
            =>
                @onClick()
        )
        @getElement().on(
            "touchend",
            =>
                @onClick()
        )

    queryServer: (n)->
        queryNumber(-1)
        queryNumber(n,
            (text)=>
                @getElementAjax().html("您第#{text}个发现了这个数")
                @getElementAjax().fadeIn(200)
        )


    getElement: ->
        $("#number-show")


    getElementNumber: ->
        $("#number-show-number")

    getElementScore: ->
        $("#number-show-score")

    getElementDescriptions: ->
        $("#number-show-descriptions")

    getElementAjax: ->
        $("#number-show-ajax")



    onClick: ()->
        if @clicked
            return
        @clicked = true
        console.log(@finished)
        @getElement().animate({opacity: "0.0"}, 200)
        setTimeout(
            =>
                @finished = true
                @getElement().hide()
            , 200
        )
        setStyleRuleValue(".number", "visibility", "visible")
#        $(".number").animate({opacity: "1.0"}, 200)

    update: ->
        @time += 1
        ratio = (1 + Math.cos(@time / @totalFrames * Math.PI)) / 2
