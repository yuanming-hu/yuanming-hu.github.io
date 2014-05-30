class NAN.RotateTask
	constructor: (@elementB, @direction = 1)->
		@frames = 100
		@timeStep = 20
		@time = 0
		@angle = 0
#		console.log($.currentScreen)
		@getElementA().css("opacity", 1)
		@getElementB().css("opacity", 0)
		@getElementA().show(0)
		@getElementB().show(0)
		@intervalId = setInterval(
			=>
				@update()
			, @timeStep
		)
		$("body").css("-webkit-perspective", "1001px")
		$.inTransition = true

	update: ()->
		@time += 1
		if @time >= @frames
			@getElementA().hide()
			@getElementB().show()
			$.currentScreen = @elementB
#			console.log($.currentScreen)
			clearInterval(@intervalId)
			$.inTransition = false


		rate = (1 - Math.cos(@time / @frames * Math.PI)) / 2
		@angle = 180 * rate
		@getElementA().css("opacity", Math.max(1 - rate * 2, 0))
		@getElementB().css("opacity", Math.max((rate - 0.5) * 2, 0))
#		console.log(rate)
		if rate >= 0.5
			rate += 1
		$("#container").css("-webkit-transform", "rotateY(#{@direction * 180 * rate}deg)")

	getElementA: ()->
		return $($.currentScreen)
	getElementB: ()->
		return $(@elementB)
