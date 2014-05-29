javascript/game-min.js: game.coffee
	coffee -c -o javascript/ game.coffee
	uglifyjs game.js > javascript/game-min.js

javascript/background-min.js: background.coffee
	coffee -c -o javascript/ background.coffee
	uglifyjs background.js > javascript/background-min.js

javascript/analyzer-min.js: analyzer.coffee
	coffee -c -o javascript/ analyzer.coffee
	uglifyjs analyzer.js > javascript/analyzer-min.js

javascript/grid-min.js: grid.coffee
	coffee -c -o javascript/ grid.coffee
	uglifyjs grid.js > javascript/grid-min.js

javascript/mouse-min.js: mouse.coffee
	coffee -c -o javascript/ mouse.coffee
	uglifyjs mouse.js > javascript/mouse-min.js

javascript/elements-min.js: elements.coffee
	coffee -c -o javascript/ elements.coffee
	uglifyjs elements.js > javascript/elements-min.js

javascript/audioPlayer-min.js: audioPlayer.coffee
	coffee -c -o javascript/ audioPlayer.coffee
	uglifyjs audioPlayer.js > javascript/audioPlayer-min.js

javascript/rotateTask-min.js: rotateTask.coffee
	coffee -c -o javascript/ rotateTask.coffee
	uglifyjs rotateTask.js > javascript/rotateTask-min.js

nan:  javascript/game-min.js javascript/background-min.js javascript/analyzer-min.js javascript/grid-min.js javascript/mouse-min.js javascript/elements-min.js javascript/audioPlayer-min.js javascript/rotateTask-min.js
	echo built