extends Node3D

signal play_string_1_requested
signal play_string_2_requested
signal play_string_3_requested
signal play_string_4_requested

enum { ST_JUST_LOAD,
 ST_WAIT_START,
 ST_PLAYING_1,
 ST_PLAYING_2,
 ST_PLAYING_3,
 ST_PLAYING_4,
 ST_PLAYING_ALL,
 ST_WAIT_USER_INPUT }

var state = ST_JUST_LOAD
var time_ref = -1
var acc = 0

const DELAY_1 = 1

func play_string(n, stop = false):
	var s
	if n == 1:
		s = play_string_1_requested
	elif n == 2:
		s =  play_string_2_requested
	elif n == 3:
		s =  play_string_3_requested
	elif n == 4:
		s =  play_string_4_requested
	else:
		print("bad string")
		return
	#we fist stop previous animation
	s.emit(n, true)
	if stop == false:
		s.emit(n)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acc = acc + delta
	if  state == ST_JUST_LOAD:
		time_ref = 0
		acc = 0
		state = ST_WAIT_START
		
	elif state == ST_WAIT_START:
		if acc > time_ref + DELAY_1/2:
			time_ref = 0
			acc = 0
			print("Play Anim 1")
			play_string(1)
			state = ST_PLAYING_1
			
	elif state == ST_PLAYING_1:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim 2")
			play_string(2)
			state = ST_PLAYING_2
			
	elif state == ST_PLAYING_2:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim 3")
			play_string(3)
			state = ST_PLAYING_3
			
	elif state == ST_PLAYING_3:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim 4")
			play_string(4)
			state = ST_PLAYING_4
			
	elif state == ST_PLAYING_4:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim All")
			#stop()
			play_string(1)
			play_string(2)
			play_string(3)
			play_string(4)

			state = ST_PLAYING_ALL
			
	elif state == ST_PLAYING_ALL:
		if acc > time_ref + DELAY_1:
			time_ref = acc
			print("Done")
			state = ST_WAIT_USER_INPUT


