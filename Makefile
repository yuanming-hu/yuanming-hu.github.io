javascript/constants-min.js: coffeescript/constants.coffee
	coffee -c -o javascript/ coffeescript/constants.coffee
	uglifyjs constants.js > javascript/constants-min.js

javascript/game-min.js: coffeescript/game.coffee
	coffee -c -o javascript/ coffeescript/game.coffee
	uglifyjs game.js > javascript/game-min.js

javascript/analyzer-min.js: coffeescript/analyzer.coffee
	coffee -c -o javascript/ coffeescript/analyzer.coffee
	uglifyjs analyzer.js > javascript/analyzer-min.js

javascript/grid-min.js: coffeescript/grid.coffee
	coffee -c -o javascript/ coffeescript/grid.coffee
	uglifyjs grid.js > javascript/grid-min.js

javascript/mouse-min.js: coffeescript/mouse.coffee
	coffee -c -o javascript/ coffeescript/mouse.coffee
	uglifyjs mouse.js > javascript/mouse-min.js

javascript/elements-min.js: coffeescript/elements.coffee
	coffee -c -o javascript/ coffeescript/elements.coffee
	uglifyjs elements.js > javascript/elements-min.js

javascript/audioPlayer-min.js: coffeescript/audioPlayer.coffee
	coffee -c -o javascript/ coffeescript/audioPlayer.coffee
	uglifyjs audioPlayer.js > javascript/audioPlayer-min.js

javascript/rotateTask-min.js: coffeescript/rotateTask.coffee
	coffee -c -o javascript/ coffeescript/rotateTask.coffee
	uglifyjs rotateTask.js > javascript/rotateTask-min.js

nan:  javascript/constants-min.js javascript/game-min.js javascript/analyzer-min.js javascript/grid-min.js javascript/mouse-min.js javascript/elements-min.js javascript/audioPlayer-min.js javascript/rotateTask-min.js
	echo built