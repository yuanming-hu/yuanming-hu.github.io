class NAN.Mouse
    
    constructor: ->
        @path = []
        @state = "none"

    checkPath: ()->
        result = true
       # console.log(@path.length)
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
      #  console.log(result)
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
            if result.score == 0
                descriptions = ""
            $.numberShow = new NAN.NumberShow
                n: numberString,
                descriptions: descriptions,
                score: result.score
            
            $.game.score.addValue(result.score)
            if result.score != 0
                for i in [0...@path.length]
                    node = @path[i]
                    $.audioPlayerB.playString(numberString)
                    node.grid.clean()
        for node in @path
            node.grid.selected = false
        @state = "none"
        @path = []

    addGrid: (grid)->
        if @path.length >= 9
            return
        if @path.length == 0 and grid.value == 0
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
