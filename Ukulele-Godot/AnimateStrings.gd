extends AnimationPlayer

@onready var game_root_node = $/root/Node3D
@onready var ukulele_node = $/root/Node3D/Ukulele

const _pitch_samples = [
	preload("res://tunes/ukulele_do_261.6.wav"), # index 0 is for low frequency
	preload("res://tunes/ukulele_la.440.wav")    # index 1 is for high freq starting with A4 (midi 69
]

var _NOTE_FACTOR = 1.05946

var _notes_factors = [
	1.0,
	1.05946,
	1.1224554916000002,
	1.1891966951305362,
	1.259906330622998,
	1.3348203610418417,
	1.4141887797093895,
	1.49827644455091,
	1.587363961943907,
	1.6817486231210919,
	1.7817453962518721,
	1.8876879775130087,
	2.0,
	2.11892,
	2.244910983,
	2.37839339,
	2.519812661,
	2.669640722,
	2.828377559
]

var _notes_names = {
	"A": 0,
	"A#": 1,
	"B": 2,
	"C": 3,
	"C#":4,
	"D":5,
	"D#":6,
	"E":7,
	"F":8,
	"F#":9,
	"G":10,
	"G#":11,
	"A+": 12,
}

const _string_midi_code = [
	69, # string 1, A4 first string, base zero (bottom)
	64, # string 2, E4
	60, # string 3, C4
	67  # string 4, G4 (top) A
]

# string is base 1, fret is base 1 but no fret values is zero
const _midi_notes = {
	60: { "name": "C4",  "factor_idx": 0, "pitch_file_idx": 0, "pos":[      [3,0]]              },
	61: { "name": "C4#", "factor_idx": 1, "pitch_file_idx": 0, "pos":[      [3,1]]              },
	62: { "name": "D4",  "factor_idx": 2, "pitch_file_idx": 0, "pos":[      [3,2]]              },
	63: { "name": "D4#", "factor_idx": 3, "pitch_file_idx": 0, "pos":[      [3,3]]              },
	64: { "name": "E4",  "factor_idx": 4, "pitch_file_idx": 0, "pos":[      [3,4],  [2,0]]      },
	65: { "name": "F4",  "factor_idx": 5, "pitch_file_idx": 0, "pos":[      [3,5],  [2,1]]      },
	66: { "name": "F4#", "factor_idx": 6, "pitch_file_idx": 0, "pos":[      [3,6],  [2,2]]      },
	67: { "name": "G4",  "factor_idx": 7, "pitch_file_idx": 0, "pos":[[4,0],[3,7],  [2,3]]      },
	68: { "name": "G4#", "factor_idx": 8, "pitch_file_idx": 0, "pos":[[4,1],[3,8],  [2,4]]      },
	69: { "name": "A4",  "factor_idx": 0, "pitch_file_idx": 1, "pos":[[4,2],[3,9],  [2,5], [1,0]]},
	70: { "name": "A4#", "factor_idx": 1, "pitch_file_idx": 1, "pos":[[4,3],[3,10], [2,6], [1,1]]},
	71: { "name": "B4",  "factor_idx": 2, "pitch_file_idx": 1, "pos":[[4,4],[3,11], [2,7], [1,2]]},
	72: { "name": "C5",  "factor_idx": 3, "pitch_file_idx": 1, "pos":[[4,5],[3,12], [2,8], [1,3]]},
	73: { "name": "D5#", "factor_idx": 4, "pitch_file_idx": 1, "pos":[[4,6],       [2,9], [1,4]]},
	74: { "name": "D5",  "factor_idx": 5, "pitch_file_idx": 1, "pos":[[4,7],       [2,10], [1,5]]},
	75: { "name": "D5#", "factor_idx": 6, "pitch_file_idx": 1, "pos":[[4,8],       [2,11], [1,6]]},
	76: { "name": "E5",  "factor_idx": 7, "pitch_file_idx": 1, "pos":[[4,9],       [2,12],[1,7]]},
	77: { "name": "F5",  "factor_idx": 8, "pitch_file_idx": 1, "pos":[[4,10],             [1,8]]},
	78: { "name": "F5#", "factor_idx": 9, "pitch_file_idx": 1, "pos":[[4,11],             [1,9]]},
	79: { "name": "G5",  "factor_idx": 10, "pitch_file_idx": 1, "pos":[[4,12],            [1,10]]},
	80: { "name": "G5#", "factor_idx": 11, "pitch_file_idx": 1, "pos":[                   [1,11]]},
	81: { "name": "A5",  "factor_idx": 12, "pitch_file_idx": 1, "pos":[                   [1,12]]},
	82: { "name": "A5#", "factor_idx": 13, "pitch_file_idx": 1, "pos":                    [[1,13]]},
	83: { "name": "B5",  "factor_idx": 14, "pitch_file_idx": 1, "pos":                    [[1,14]]},
	84: { "name": "C5",  "factor_idx": 15, "pitch_file_idx": 1, "pos":                    [[1,15]]},
}
const _string_animation_names = [
	"dummy_base_1", "String-1", "String-2", "String-3", "String-4", 
]

func _play_animation(string_num_base_1):
	stop()
	play(_string_animation_names[string_num_base_1])

func _on_play(v, _stop = false):
	print("_on_play: " + str(v))
	var s
	var note = ""
	if v == 1:
		s = "String-1"
		note = _string_midi_code[0]
	elif v == 2:
		s = "String-2"
		note = _string_midi_code[1]
	elif v == 3:
		s = "String-3"
		note = _string_midi_code[2]
	elif v == 4:
		s = "String-4"
		note = _string_midi_code[3]
	else:
		print("wrong node")
		return
	if _stop == true:
		stop()
	else:
		play(s)
		_play_note(note)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name == "AnimationPlayer_1":
		ukulele_node.play_string_1_requested.connect(_on_play)
	elif self.name == "AnimationPlayer_2":
		ukulele_node.play_string_2_requested.connect(_on_play)
	elif self.name == "AnimationPlayer_3":
		ukulele_node.play_string_3_requested.connect(_on_play)
	elif self.name == "AnimationPlayer_4":
		ukulele_node.play_string_4_requested.connect(_on_play)
	ukulele_node.play_MIDI_requested.connect(_on_midi_play)

func _on_midi_play(code, string_base_1):
	if self.name == "AnimationPlayer_1" && string_base_1 != 1:
		return
	if self.name == "AnimationPlayer_2" && string_base_1 != 2:
		return
	if self.name == "AnimationPlayer_3" && string_base_1 != 3:
		return
	if self.name == "AnimationPlayer_4" && string_base_1 != 4:
		return
	_play_animation(string_base_1)
	_play_note(code)

func _play_note(n):
	print("_play_note code: " + str(n))
	if _midi_notes.has(n) == false:
		print("bad note code: " + str(n))
		return
		# "factor_idx": 0, "pitch_file_idx"
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	print("_midi_notes[n].pitch_file_idx: " + str(_midi_notes[n].pitch_file_idx))
	audio.stream = _pitch_samples[_midi_notes[n].pitch_file_idx]  #preload("res://tunes/ukulele_la.440.wav")
	var factor_idx = _midi_notes[n].factor_idx
	print("factor idx = " + str(factor_idx))
	audio.pitch_scale = _notes_factors[factor_idx ]  #_notes_factors[_notes_names[n]]
	audio.play()
	#color_timer.start()
	await get_tree().create_timer(8.0).timeout
	audio.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

