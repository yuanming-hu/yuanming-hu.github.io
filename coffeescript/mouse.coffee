class NAN.Mouse
    
    constructor: ->
        @path = []
        @state = "none"

    checkPath: ()->
        result = true
        if @path.length < 2
            gameHint("请拖动来选择2到8个数字")
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
        inside = false
        for i in [0...@path.length]
            node = @path[i]
            if node.x == grid.x and node.y == grid.y
                inside = true
                console.log(123)
                for j in [(i + 1)...@path.length]
                    @path[j].grid.selected = false
                @path = @path.slice(0, i + 1)
                return
        if @path.length >= 8
            gameHint("最长只能是8个数字T_T")
            return
        if @path.length == 0 and grid.value == 0
            gameHint("不能以0开始哦")
            return

        if not inside
            if @path.length == 0 or @path[@path.length - 1].grid.isConnecting(grid)
                grid.makeSound()
                grid.selected = true
                node = {x: grid.x, y: grid.y, grid: grid}
                @path.push(node)
