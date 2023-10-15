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

 ST_START_MIDI,
 ST_PLAYING_MIDI,
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
#var _state = ST_JUST_LOAD

var _time_ref = -1
var _acc = 0

const _DELAY_1 = 1

func _play_string(n, stop = false):
	var s
	if n == 1:
		s = 69
	elif n == 2:
		s =  64
	elif n == 3:
		s =  60
	elif n == 4:
		s =  67
	else:
		print("bad string")
		return
	play_MIDI_requested.emit(s, n)

		
# Called when the node enters the scene tree for the first time.
func _ready():
	var midi_parser = SMF.new()
	var r = midi_parser.read_file("res://midis/Ammerbach-Passamezzo-Antico.mid")
	print("parsed Ammerbach-Passamezzo-Antico.mid")
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
	
	elif _state == ST_START_MIDI:
		_event_idx = -1
		_time_ref = 0
		_acc = 0
		_state = ST_PLAYING_MIDI	
		
	elif _state == ST_PLAYING_MIDI:
		if _acc > _time_ref + 0.100:
			_event_idx += 1
			if _event_idx >= _active_events_array.size():
				print("MIDI done")
				_state = ST_WAIT_USER_INPUT
			else:
				var e = _active_events_array[_event_idx]
				if e.event.type == SMF.MIDIEventType.note_on:
					print("play note: " + str(e.event.note))
					play_MIDI_requested.emit(e.event.note, 1)
				_time_ref = 0
				_acc = 0
				
			
			
					
	elif _state == ST_PLAYING_ALL:
		if _acc > _time_ref + _DELAY_1:
			_time_ref = _acc
			print("Done")
			_state = ST_WAIT_USER_INPUT
			
var _midi_obj = null
var _active_events_array = null
var _event_idx = 0

func _play_midi_file(filename):
	var midi_parser = SMF.new()
	_midi_obj = midi_parser.read_file(filename)
	if _midi_obj.error != OK:
		print("Parser error for file: " + filename)
		return
	print("midi file: " + filename)
	print("  timiebase: " + str(_midi_obj.data.timebase))
	print("  num tracks: " + str(_midi_obj.data.track_count))
	var max_track = -1
	if _midi_obj.data.track_count < 0:
		print("No track found")
		return

	for t in _midi_obj.data.tracks:
		print( "    track_number " + str(t.track_number) + " has " + str(t.events.size()) + " events")
		if t.events.size() > max_track:
			_active_events_array = t.events
			max_track = t.events.size()
		_state = ST_START_MIDI

func _input(event):
	#print(event.as_text())
#	if event is InputEventMouseButton:
#		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
#			print("is InputEventMouseButton")
#			_time_ref = 0
#			_acc = 0
#			_state = ST_WAIT_START
	if event is InputEventKey:
		if event.pressed:
			if _key_to_note.has(event.keycode):
				play_MIDI_requested.emit(_key_to_note[event.keycode].midi_code, _key_to_note[event.keycode].string)
			elif event.keycode == KEY_P:
				_play_midi_file("res://midis/Ammerbach-Passamezzo-Antico.mid")
			elif event.keycode == KEY_L:
				_time_ref = 0
				_acc = 0
				_state = ST_WAIT_START
		
