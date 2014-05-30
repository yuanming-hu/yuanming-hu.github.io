#Import the library

from midiutil.MidiFile import MIDIFile
import os


plist = [69, 71, 72, 74, 76, 77, 79, 81, 83, 84]
#plist = [60, 71, 71, 67, 69, 72, 74, 76, 79, 81]


def generate(n, program, suffix, sf = "/usr/share/sounds/sf2/FluidR3_GM.sf2", volume = 100):
	MyMIDI = MIDIFile(2)
	track = 0   
	time = 0
	MyMIDI.addTrackName(track,time,"Test")
	MyMIDI.addTempo(track,time,30)
	track = 0
	channel = 0
	time = 0
	duration = 2.0
	MyMIDI.addProgramChange(track, channel, 0, program)
	MyMIDI.addNote(track,channel, plist[n], 0,duration,volume)
	binfile = open("output.mid", 'wb')
	MyMIDI.writeFile(binfile)
	binfile.close()

	os.system("fluidsynth %s output.mid -F output.wav --sample-rate 1000"  % sf)
	os.system("lame -V 7 output.wav sound%d%s.mp3" % (n, suffix))
	os.system("rm output.mid")
#	os.system("mplayer output.wav")
	os.system("rm output.wav")

	

for i in range(10):
	generate(i, 10, "a")

for i in range(10):
	generate(i, 0, "b", "'Piano.sf2'")
#	generate(i, 0, "b", "'musicbox.sf2'")
