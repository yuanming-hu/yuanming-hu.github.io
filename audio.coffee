class NAN.AudioPlayer
	constructor:()->
		@sounds = []
		for i in [0...10]
			@sounds.push( new Audio("sound/sound#{i}.mp3")


	play: (n)->
		@sounds[n].play()