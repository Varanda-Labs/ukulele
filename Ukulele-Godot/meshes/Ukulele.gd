extends Node3D

signal play_string_1_requested
signal play_string_2_requested
signal play_string_3_requested
signal play_string_4_requested
signal play_MIDI_requested

enum { ST_JUST_LOAD,
 ST_WAIT_START,
 ST_PLAYING_1,
 ST_PLAYING_2,
 ST_PLAYING_3,
 ST_PLAYING_4,
 ST_PLAYING_ALL,
 ST_WAIT_USER_INPUT }

#	69, # string 1, A4 first string, base zero (bottom)
#	64, # string 2, E4
#	60, # string 3, C4
#	67  # string 4, G4 (top) A
	
const _key_to_note = {
	KEY_1: { "midi_code" = 69, "string" = 1},
	KEY_2: { "midi_code" = 70, "string" = 1},
	KEY_3: { "midi_code" = 71, "string" = 1},
	KEY_4: { "midi_code" = 72, "string" = 1},
	KEY_5: { "midi_code" = 73, "string" = 1},
	KEY_6: { "midi_code" = 74, "string" = 1},
	KEY_7: { "midi_code" = 75, "string" = 1},
	KEY_8: { "midi_code" = 76, "string" = 1},
	
	KEY_Q: { "midi_code" = 64, "string" = 2},
	KEY_W: { "midi_code" = 65, "string" = 2},
	KEY_E: { "midi_code" = 66, "string" = 2},
	KEY_R: { "midi_code" = 67, "string" = 2},
	KEY_T: { "midi_code" = 68, "string" = 2},
	KEY_Y: { "midi_code" = 69, "string" = 2},
	KEY_U: { "midi_code" = 70, "string" = 2},
	KEY_I: { "midi_code" = 71, "string" = 2},

	KEY_A: { "midi_code" = 60, "string" = 3},
	KEY_S: { "midi_code" = 61, "string" = 3},
	KEY_D: { "midi_code" = 62, "string" = 3},
	KEY_F: { "midi_code" = 63, "string" = 3},
	KEY_G: { "midi_code" = 64, "string" = 3},
	KEY_H: { "midi_code" = 65, "string" = 3},
	KEY_J: { "midi_code" = 66, "string" = 3},
	KEY_K: { "midi_code" = 67, "string" = 3},

	KEY_Z: { "midi_code" = 67, "string" = 4},
	KEY_X: { "midi_code" = 68, "string" = 4},
	KEY_C: { "midi_code" = 69, "string" = 4},
	KEY_V: { "midi_code" = 70, "string" = 4},
	KEY_B: { "midi_code" = 71, "string" = 4},
	KEY_N: { "midi_code" = 72, "string" = 4},
	KEY_M: { "midi_code" = 73, "string" = 4},
	KEY_COMMA: { "midi_code" = 74, "string" = 4},
}

var _state = ST_WAIT_USER_INPUT # ST_JUST_LOAD
var _time_ref = -1
var _acc = 0

const _DELAY_1 = 1

func _play_string(n, stop = false):
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
	_acc = _acc + delta
	if  _state == ST_JUST_LOAD:
		_time_ref = 0
		_acc = 0
		_state = ST_WAIT_START
		
	elif _state == ST_WAIT_START:
		if _acc > _time_ref + _DELAY_1/2:
			_time_ref = 0
			_acc = 0
			print("Play Anim 1")
			_play_string(1)
			_state = ST_PLAYING_1
			
	elif _state == ST_PLAYING_1:
		if _acc > _time_ref + _DELAY_1:
			_time_ref = 0
			_acc = 0
			print("Play Anim 2")
			_play_string(2)
			_state = ST_PLAYING_2
			
	elif _state == ST_PLAYING_2:
		if _acc > _time_ref + _DELAY_1:
			_time_ref = 0
			_acc = 0
			print("Play Anim 3")
			_play_string(3)
			_state = ST_PLAYING_3
			
	elif _state == ST_PLAYING_3:
		if _acc > _time_ref + _DELAY_1:
			_time_ref = 0
			_acc = 0
			print("Play Anim 4")
			_play_string(4)
			_state = ST_PLAYING_4
			
	elif _state == ST_PLAYING_4:
		if _acc > _time_ref + _DELAY_1:
			_time_ref = 0
			_acc = 0
			print("Play Anim All")
			#stop()
			_play_string(1)
			_play_string(2)
			_play_string(3)
			_play_string(4)

			_state = ST_PLAYING_ALL
			
	elif _state == ST_PLAYING_ALL:
		if _acc > _time_ref + _DELAY_1:
			_time_ref = _acc
			print("Done")
			_state = ST_WAIT_USER_INPUT

func _input(event):
	#print(event.as_text())
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("is InputEventMouseButton")
			_time_ref = 0
			_acc = 0
			_state = ST_WAIT_START
	if event is InputEventKey:
		if event.pressed and _key_to_note.has(event.keycode):
			play_MIDI_requested.emit(_key_to_note[event.keycode].midi_code, _key_to_note[event.keycode].string,)
		
