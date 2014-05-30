class NAN.Mouse
    
    constructor: ->
        @path = []
        @state = "none"

    checkPath: ()->
        result = true
        if @path.length < 2
            result = false
        if @path.length > 0
            for i in [0...(@path.length - 1)]
                if @path[i].grid.isConnecting(@path[i + 1].grid) == false
                    result = false
        return result

    evaluatePath: ()->
        result = ""
        for node in @path
            val = node.grid.value
            result += val.toString()
        return result

    beginPath: ()->
        @path = []
        @state = "select"

    endPath: ()->
        if @state == "none" or $.game.gameOver
            return
        if @checkPath() and not $.numberShow
            numberString = @evaluatePath()
            result = $.analyzer.analyze(numberString)
            descriptions = result.descriptions.filter(
                    (desc)->
                        return desc != null and desc != ""
                    ).join("<br>")
            if result.score == 0 # and descriptions == ""
                gameHint("这只是一个平凡的数, 放了它吧")
            else
                $.numberShow = new NAN.NumberShow
                    n: numberString,
                    descriptions: descriptions,
                    score: result.score
                
                $.game.score.addValue(result.score)
                $.audioPlayerB.playString(numberString)

                if result.score != 0
                    for i in [0...@path.length]
                        node = @path[i]
                        node.grid.clean()
        for node in @path
            node.grid.selected = false
        @state = "none"
        @path = []

    addGrid: (grid)->
        if @path.length >= 8
            return
        if @path.length == 0 and grid.value == 0
            gameHint("不能以0开始哦")
            return
        inside = false
        for node in @path
            if node.x == grid.x and node.y == grid.y
                inside = true
        if not inside
            if @path.length == 0 or @path[@path.length - 1].grid.isConnecting(grid)
                grid.makeSound()
                grid.selected = true
                node = {x: grid.x, y: grid.y, grid: grid}
                @path.push(node)
