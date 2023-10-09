extends Node3D

signal play_string_1_requested
signal play_string_2_requested
signal play_string_3_requested
signal play_string_4_requested

var done = false

func play_string(n):
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
	s.emit(n)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if done == false:
		done = true
		#play_string_1_requested.emit("abc")
		play_string(1)
		play_string(2)
		play_string(3)
		play_string(4)

