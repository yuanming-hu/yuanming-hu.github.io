javascript/constants-min.js: coffeescript/constants.coffee
	coffee -c -o javascript/ coffeescript/constants.coffee
	uglifyjs javascript/constants.js > javascript/constants-min.js

javascript/game-min.js: coffeescript/game.coffee
	coffee -c -o javascript/ coffeescript/game.coffee
	uglifyjs javascript/game.js > javascript/game-min.js

javascript/analyzer-min.js: coffeescript/analyzer.coffee
	coffee -c -o javascript/ coffeescript/analyzer.coffee
	uglifyjs javascript/analyzer.js > javascript/analyzer-min.js

javascript/grid-min.js: coffeescript/grid.coffee
	coffee -c -o javascript/ coffeescript/grid.coffee
	uglifyjs javascript/grid.js > javascript/grid-min.js

javascript/mouse-min.js: coffeescript/mouse.coffee
	coffee -c -o javascript/ coffeescript/mouse.coffee
	uglifyjs javascript/mouse.js > javascript/mouse-min.js

javascript/elements-min.js: coffeescript/elements.coffee
	coffee -c -o javascript/ coffeescript/elements.coffee
	uglifyjs javascript/elements.js > javascript/elements-min.js

javascript/audioPlayer-min.js: coffeescript/audioPlayer.coffee
	coffee -c -o javascript/ coffeescript/audioPlayer.coffee
	uglifyjs javascript/audioPlayer.js > javascript/audioPlayer-min.js

javascript/rotateTask-min.js: coffeescript/rotateTask.coffee
	coffee -c -o javascript/ coffeescript/rotateTask.coffee
	uglifyjs javascript/rotateTask.js > javascript/rotateTask-min.js

nan:  javascript/constants-min.js javascript/game-min.js javascript/analyzer-min.js javascript/grid-min.js javascript/mouse-min.js javascript/elements-min.js javascript/audioPlayer-min.js javascript/rotateTask-min.js
	echo built