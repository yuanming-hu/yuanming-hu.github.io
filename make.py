import os
import time

files = ["game", "background", "analyzer", "grid", "mouse", "elements", "audioPlayer", "rotateTask"]

makefile = open("Makefile", "w")


makestr = ""

for f in files:
	makestr += "javascript/%s-min.js: %s.coffee\n" % (f, f)
	makestr += chr(9) + "coffee -c -o javascript/ %s.coffee\n" % (f,)
	makestr += chr(9) + "uglifyjs %s.js > javascript/%s-min.js\n" % (f, f)
	makestr += "\n"

makestr += "nan: "
for f in files: 
	makestr += " javascript/%s-min.js" % f
makestr += "\n"
makestr += chr(9) + "echo built"

makefile.write(makestr)
makefile.close()

while True:
	time.sleep(0.1)
	for f in files:
		os.system("make nan")
