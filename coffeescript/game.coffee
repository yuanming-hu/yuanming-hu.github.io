
class NAN.Game
    constructor: (instance = true)->
        @hint = 0
        if instance
            $.audioPlayerA.playString("0123456789")
            @hintEvent = 0
            if $.gameMode in [$.modeOCD, $.modeEndless]
                @hint = setInterval(
                    ->
                        gameHint("如果不想玩了或者没有数可以消除, 可以点击右上角的结束游戏")
                    , 15000
                )

        $.backgroundBlockId = 0
        @score = new NAN.Score
        @gridId = 0
        @init()
        @gridMargin = 2
        @containerHeight = 670
        @containerWidth = 600
        @numGridRows = 5
        @numGridColumns = 5
        @numGrids = @numGridColumns * @numGridRows
        @gridWidth = (@containerWidth - 100) / @numGridRows
        @gridHeight = @gridWidth
        @gridXOffset = 110
        @gridYOffset = (@containerWidth - @numGridColumns * @gridWidth) / 2
        setStyleRuleValue(".board", "width", "#{@containerWidth}px")
        setStyleRuleValue(".board", "height", "#{@containerHeight}px")
        setStyleRuleValue(".number", "line-height", "#{@gridHeight}px")
        setStyleRuleValue(".square", "height", "#{@gridHeight - @gridMargin * 2}px")
        setStyleRuleValue(".square", "width", "#{@gridWidth - @gridMargin * 2}px")
        @gameOver = false
        @grids = []
        @mouse = new NAN.Mouse
        @paused = true
        @timeLeft = 60
        @timeTotal = 60
        @gridQueue = []
        for i in [0...@numGridRows]
            @grids[i] = []
#        @initTouchScreen()
        @startTime = getTime()
        @gridsToShow = []

    getEventPosition: (e)->
        y = e.originalEvent.targetTouches[0].pageX - $("#container").offset().left
        x = e.originalEvent.targetTouches[0].pageY - $("#container").offset().top
        return {x: x, y : y}

    getEventGrid: (e)->
        pos = @getEventPosition(e)
        return @getGridAt(pos.x, pos.y)


    newGrid: (x, y, show = true)->
        grid = new NAN.Grid(x, y, this, show)
        @grids[x][y] = grid
        @gridQueue.push(grid)

    getGridAt: (x, y)->
        for grid in @gridQueue
            if grid.testInside(x, y)
                return grid
        return null


    init: ->
        @time = 0

    movementEnd: ->
        result = true
        for row in @grids
            for grid in row
                if grid != null and grid.deltaX != 0
                    result = false
        return result

    nextFrame: ->
        for x in [0...@numGridRows].reverse()
            for y in [0...@numGridColumns]
                if @grids[x][y] == null or not @grids[x][y].exist
                    if x > 0 and @grids[x - 1][y] != null
                        @grids[x - 1][y].deltaX += @gridHeight
                        @grids[x][y] = @grids[x - 1][y]
                        @grids[x - 1][y].moveTo(x, y)
                        @grids[x - 1][y] = null
                    else if x == 0
                        if $.gameMode != $.modeOCD
                            @newGrid(x, y, false)
                            @gridsToShow.push(@grids[x][y])
                            @grids[x][y].getElement().hide()
                            @grids[x][y].getElement().css("opacity", 0.0)

    updateGrids: () ->
        newQueue = []
        for grid in @gridQueue
            if grid == null or grid.exist == false
                0
            else
                grid.update()
                newQueue.push(grid)
        @gridQueue = newQueue

    getPaused: ->
        if @gameOver
            return true
        if @time <= 60
            return true
        if $.numberShow and not $.numberShow.finished
            return true
        if not @movementEnd()
            return true
        return false

    update: ->
        @paused = @getPaused()
        if @time < @numGridRows * 5
            if @time % 5 == 0
                x = @time / 5
                for y in [0...@numGridColumns]
                    @newGrid(x, y)
        else
            @nextFrame()
        if @movementEnd()
            for grid in @gridsToShow
                grid.show()
            @gridsToShow = []
        @updateGrids()   
        @score.update()
        @time += 1
        if $.numberShow
            $.numberShow.update()
            if $.numberShow.finished
                $.numberShow = null

        @updateTimeLeft()
        if $.gameMode == $.modeOCD and @gridQueue.length <= 1
            @over()

        $("#progressbar").attr("value", "#{@timeLeft / @timeTotal * 100}")

    updateTimeLeft: ()->
        if $.gameMode in [$.modeClassic, $.modeAdvanced]
            if not @paused
                @timeLeft -= 0.02
            if @timeLeft > 60
                @timeLeft = 60
            if @timeLeft < 5
                $("#game-count-down").css("color", "#f44")
            else
                $("#game-count-down").css("color", "#454")

            $("#game-count-down").html(Math.max(0, Math.floor(@timeLeft)))
            if @timeLeft <= 0
                @over()
        else 
            $("#game-count-down").html("NaN")

    over: ()->
        if @gameOver
            return
        @gameOver = true
        if @hint
            clearInterval(@hint)
        $("#game-over-mode-hint").html($.modeChinese[$.gameMode])
        if $.numberShow and not $.numberShow.finished
            $.numberShow.onClick()
        $.audioPlayerA.playString("9876543210")
        delay = 2000
        @finalScore = Math.floor(@score.value)
        @score.addValue(-@finalScore)
        new NAN.RotateTask("#game-over-screen", -1)
#        if @timeLeft >= 0
        $(".score").fadeOut(500)
        if $.gameMode == $.modeOCD
            ratio = 3 / (3 + @gridQueue.length)
            @finalScore *= ratio
            @finalScore = Math.floor(@finalScore)
            prefix = ""
            if @gridQueue.length == 0
                prefix = "消除了全部方块"
            else
                prefix = "剩余#{@gridQueue.length}个方块"
            $("#ocd-hint").html("#{prefix}, 获得#{Math.floor(ratio * 100)}%分数")

        $.shareScore = @finalScore

        setTimeout(
            =>
                @score.addValue(@finalScore)
                $(".score").fadeIn(500)
#                $.audioPlayerB.playString(@finalScore.toString() + @finalScore.toString().split("").reverse().join(""))
            , delay
        )

        setTimeout(
            =>
                $.audioPlayerA.playString(@finalScore.toString())
                $.audioPlayerB.playString(@finalScore.toString())
            , delay * 1.5
        )


        rrShareParam = {
            resourceUrl : 'http://iteratoradvance.github.io/', 
            srcUrl : 'http://iteratoradvance.github.io/',
            pic : '',
            title : 'Not A Number! 发现隐藏在数字中的秘密! 4种游戏模式供您选择, 挑战你的数学直觉!',
            description : "我在[#{$.modeChinese[$.gameMode]}]中获得 [#{$.shareScore}] 分, 快来和我一比高下吧!"
        }
        $("#game-over-share-anchor").attr("href", rrGetUrl(rrShareParam))


@gameHint = (text)->
    $("#game-area-hint").html(text)
    $("#game-area-hint").fadeIn(150)
    setTimeout(
        ->
            $("#game-area-hint").fadeOut(150)
        , 2200
    )

@switchToNanScreen = ->
    new NAN.RotateTask("#nan-screen")
    queryNumber(0,
        (num)->
            $.totalPlayers = num
        , 0
        
    )
    queryNumber(-1,
        (num)->
            $.totalNumbers = num
        , 0
    )

@newGame = ->
    $("#number-show").hide(0)
    $("#game-area").hide(0)
    new NAN.RotateTask("#game-area")
    $.game = new NAN.Game
    if $.gameUpdater
        clearInterval($.gameUpdater)
    timeStep = 0.7
    setTimeout(
        ->
            gameHint("连出你认为特殊的数字")
        , 2500
    )

    setTimeout(
        ->
            gameHint("数字性质越特殊, 分数越高")
        , 5100
    )

    $(".square").remove()
    $("#number-show").hide()
    $("#number-show").css("opacity", "0.0")
    $("#how-to-play").slideUp(0)
    setTimeout(
        ->
            $.gameUpdater = setInterval(
                -> 
                    $.game.update()
                , 
                20
            )
        ,
        2000 * timeStep
    )

#$.dataServer = "http://59.66.130.206:3000/"
$.dataServer = "http://4.getwb.sinaapp.com/counter/"

@queryNumber = (number, func, inc = 1)->
    cmd = ""
    console.log(inc)
    if inc == 1
        cmd = "inc.php"
    else
        cmd = "check.php"
    $.ajax(
#        timeout : 3000,
        type: "GET",
        url: "#{$.dataServer}#{cmd}?num=#{number}"
    ).done(
        (text)->
            if func
                func(text)
    )

@listenClick = (ele, func)->
    ele.click(
        =>
            func()
    )
    ele.on(
        "touchstart",
        =>
            func()
    )

@changeMode = (mode)->
    $.gameMode = mode
    $("#mod-explanation").html($.modeChinese[mode] + "<br>" + $.modeExplanations[mode])
    $("#game-mode-hint").html($.modeChinese[mode])
    if $.gameMode != $.modeOCD
        $("#ocd-hint").hide(0)
    else
        $("#ocd-hint").show(0)



@init = ()->
    $("#number-show").hide(0)
    $("#game-area").hide(0)
    $("#game-area-hint").hide(0)
    $("#container").css("opacity", 0.0)
    $("#container").css("visibility", "visible")
    $("#container").animate({opacity: 1.0}, 1000)
    $("#container").show()
    $.totalPlayers = "many"
    $.totalNumbers = "lots of"
    $("#nan-screen").hide(0)
    setInterval(
        ->
            $("#nan-player-count").html("and #{$.totalPlayers} players with #{$.totalNumbers} numbers")
        , 100
    )
    queryNumber(0,
        (text)->
            $("#welcome-screen-user-count").html("你是第#{text}个玩家")
    )
    $.currentScreen = "#welcome-screen"
    $.mobileMode = mobileMode()
    if $.mobileMode
        queryNumber(-3)

    if $.mobileMode
        setStyleRuleValue(".square:hover", "border-radius", "20%")
        
    $.audioPlayerA = new NAN.AudioPlayer("a")
    $.audioPlayerB = new NAN.AudioPlayer("b")
    $.audioPlayerB.playString("02468")
    $.analyzer = new window.NAN.Analyzer
    $.game = new NAN.Game(false)
    $.inTransition = false
    $.modeClassic = "classic"
    $.modeAdvanced = "advanced"
    $.modeOCD = "OCD"
    $.modeEndless = "endless"
    $.gameModes = [$.modeClassic, $.modeAdvanced, $.modeOCD, $.modeEndless]
    $.gameMode = $.modeClassic
    $.modeExplanations = []
    $.modeChinese = []
    $.modeChinese[$.modeClassic] = "经典模式"
    $.modeChinese[$.modeAdvanced] = "进阶模式"
    $.modeChinese[$.modeOCD] = "强迫模式"
    $.modeChinese[$.modeEndless] = "无尽模式"
    $.modeExplanations[$.modeClassic] = "在60s内获得尽可能高的分数"
    $.modeExplanations[$.modeAdvanced] = "时间限制60s, 得到有意义的数加1秒, 否则减2秒"
    $.modeExplanations[$.modeOCD] = "方块不会补充, 必须消除全部方块, 否则分数大打折扣"
    $.modeExplanations[$.modeEndless] = "没有任何限制, 任君体验"
    changeMode($.modeClassic)
#    console.log($.modeExplanations)
    for mode in $.gameModes
        generator = (mode)->
            ()->
                changeMode(mode)
                return false


        listenClick(
            $("#mod-select-#{mode}"),
            generator(mode)
        )


    listenClick($("#game-over-hint"),
        =>
            if not $.inTransition
                newGame()
    )
    listenClick(
        $("#welcome-screen"),
        =>
            if not $.inTransition
                newGame()
    )

    ###
    listenClick(
        $("#game-over-share"),
        =>
            rrShareParam = {
                    resourceUrl : 'http://iteratoradvance.github.io/', 
                    srcUrl : 'http://iteratoradvance.github.io/',
                    pic : '',
                    title : 'Not A Number! 发现隐藏在数字中的秘密! 4种游戏模式供您选择, 挑战你的数学直觉!',
                    description : "我在[#{$.modeChinese[$.gameMode]}]中获得 [#{$.shareScore}] 分, 快来和我一比高下吧!"
                }
            rrShareOnclick(rrShareParam);
#            window.open("http://share.renren.com/share/buttonshare.do?link=http%3A%2F%2Fiteratoradvance%2Egithub%2Eio%2F&title=http%3A%2F%2Fiteratoradvance%2Egithub%2Eio%2F")
            queryNumber(-2)
    )
    ###
    
    listenClick(
        $("#nan-screen"),
        =>
            if not $.inTransition
                newGame()
    )

    listenClick(
        $("#game-over-nan"),
        =>
            if not $.inTransition
                switchToNanScreen()
    )
    listenClick(
        $("#manual-game-over"),
        =>
            $.game.over()
    )

    listenClick(
        $("#game-over-other"),
        =>
            new NAN.RotateTask("#welcome-screen", -1)
    )

    $("body").mouseup(
        ->
            $.game.mouse.endPath()
    )

    $("#game-over-screen").hide(0)


    $("#container").on("touchstart",
        (e)=>
            grid = $.game.getEventGrid(e)
            if grid
                grid.mouseDown()
            return false
    )
    $("#container").on("touchmove",
        (e)=>
            grid = $.game.getEventGrid(e)
            if grid
                grid.mouseOver()
            console.log(grid)
            return false
    )
    $("#container").on("touchend",
        (e)=>
            $.game.mouse.endPath()
            return false
    )



$(document).ready( ->
    init()
)

