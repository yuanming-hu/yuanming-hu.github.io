@mobileMode = ()->
	if navigator.appVersion.indexOf("iPad") != -1
		return true
	if navigator.appVersion.indexOf("iOS") != -1
		return true
	if navigator.appVersion.indexOf("iPhone") != -1
		return true
	if navigator.appVersion.indexOf("Android") != -1
		return true
	return false

class window.AudioTask
	constructor:(@n, timeout, @audioPlayer)->
		setTimeout(
			=>
				@play()
			, timeout
		)
		return

	play: ()->
		@audioPlayer.play(@n, 1.0)



class window.AudioSystem
	constructor: ->
		@disabled = window.mobileMode()
		if @disabled
			console.info 'Mobile mode on. Sound disabled.'
			return
		@sounds = {}
		@copies = 10
		@pointer = []

	load_file: (filename)->
		if filename of @sounds
			return
#		setTimeout(
#			=>
#				@pointer[filename] = 0
#				@sounds[filename] = []
#				fileType = "wav"
#				@sounds[filename][0] = new Audio("sound/#{filename}.#{fileType}")
#				@sounds[filename][0].load()
#				for j in [1...@copies]
#					@sounds[filename][j] = @sounds[filename][0].cloneNode(true)
#					@sounds[filename][j].load()
#			, 0
#		)

		@pointer[filename] = 0
		@sounds[filename] = []
		fileType = "mp3"
		@sounds[filename][0] = new Audio("sound/#{filename}.#{fileType}")
		@sounds[filename][0].load()
		for j in [1...@copies]
			@sounds[filename][j] = @sounds[filename][0].cloneNode(true)
			@sounds[filename][j].load()


	play: (filename, volume = 0.7) ->
#		return if @disabled
#		console.log "play #{filename}"
#		@load_file(filename)
#		sound = @sounds[filename][@pointer[filename]]
#		@pointer[filename] = (@pointer[filename] + 1) % @copies
#		sound.volume = volume
#		sound.load = 'auto'
#		console.log(sound)
#		replay = ->
#			sound.currentTime = 0
#			sound.play()
#		sound.addEventListener('ended', replay, false)
#		sound.play()
		howl = new Howl
			urls: ["sound/#{filename}.wav"]
			loop: true
			volume: volume
		howl.play()
