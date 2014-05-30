import os
import time

files = ["constants", "game", "analyzer", "grid", "mouse", "elements", "audioPlayer", "rotateTask"]

makefile = open("Makefile", "w")

makestr = ""

for f in files:
	makestr += "javascript/%s-min.js: coffeescript/%s.coffee\n" % (f, f)
	makestr += chr(9) + "coffee -c -o javascript/ coffeescript/%s.coffee\n" % (f,)
	makestr += chr(9) + "uglifyjs javascript/%s.js > javascript/%s-min.js\n" % (f, f)
	makestr += "\n"

makestr += "nan: "
for f in files: 
	makestr += " javascript/%s-min.js" % f
makestr += "\n"
makestr += chr(9) + "echo built"

makefile.write(makestr)
makefile.close()

header = open("html_header", "w")
for f in files:
	header.write('<script type="text/javascript" src="javascript/%s-min.js" charset="utf-8"> </script>\n' % f)
header.close()


while True:
	time.sleep(0.1)
	for f in files:
		os.system("make nan")
