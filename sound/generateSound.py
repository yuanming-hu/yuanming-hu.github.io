#Import the library

from midiutil.MidiFile import MIDIFile
import os


plist = [69, 71, 72, 74, 76, 77, 79, 81, 83, 84]

def generate(n, program, suffix):
	MyMIDI = MIDIFile(2)
	track = 0   
	time = 0
	MyMIDI.addTrackName(track,time,"Test")
	MyMIDI.addTempo(track,time,30)
	track = 0
	channel = 0
	time = 0
	duration = 1.5
	volume = 100
	MyMIDI.addProgramChange(track, channel, 0, program)
	MyMIDI.addNote(track,channel, plist[n], 0,duration,volume)
	binfile = open("output.mid", 'wb')
	MyMIDI.writeFile(binfile)
	binfile.close()

	os.system("fluidsynth /usr/share/sounds/sf2/FluidR3_GM.sf2 output.mid -F output.wav --sample-rate 1000")
	os.system("lame -V 7 output.wav sound%d%s.mp3" % (n, suffix))
	os.system("rm output.mid")
	os.system("rm output.wav")

	

for i in range(10):
	generate(i, 3, "a")

for i in range(10):
	generate(i, 10, "b")
