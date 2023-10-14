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
	71, # string 1, first string, base zero (bottom)
	66, # string 2
	62, # string 3
	69  # string 4 (top)
]

const _midi_notes = {
	62: { "name": "D4",  "factor_idx": 0, "pitch_file_idx": 0, "pos":[      [2,0]]              },
	63: { "name": "D4#", "factor_idx": 1, "pitch_file_idx": 0, "pos":[      [2,1]]              },
	64: { "name": "E4",  "factor_idx": 2, "pitch_file_idx": 0, "pos":[      [2,2]]              },
	65: { "name": "F4",  "factor_idx": 3, "pitch_file_idx": 0, "pos":[      [2,3]]              },
	66: { "name": "F4#", "factor_idx": 4, "pitch_file_idx": 0, "pos":[      [2,4], [1,0]]       },
	67: { "name": "G4",  "factor_idx": 5, "pitch_file_idx": 0, "pos":[      [2,5], [1,1]]       },
	68: { "name": "G4#", "factor_idx": 6, "pitch_file_idx": 0, "pos":[      [2,6], [1,2]]       },
	69: { "name": "A4",  "factor_idx": 0, "pitch_file_idx": 1, "pos":[[3,0],[2,7], [1,3]]       },
	70: { "name": "A4#", "factor_idx": 1, "pitch_file_idx": 1, "pos":[[3,1],[2,8], [1,4]]       },
	71: { "name": "B4",  "factor_idx": 2, "pitch_file_idx": 1, "pos":[[3,2],[2,9], [1,5], [0,0]]},
	72: { "name": "C5",  "factor_idx": 3, "pitch_file_idx": 1, "pos":[[3,3],[2,10],[1,6], [0,1]]},
	73: { "name": "D5#", "factor_idx": 4, "pitch_file_idx": 1, "pos":[[3,4],[2,11],[1,7], [0,2]]},
	74: { "name": "D5",  "factor_idx": 5, "pitch_file_idx": 1, "pos":[[3,5],[2,12],[1,8], [0,3]]},
	75: { "name": "D5#", "factor_idx": 6, "pitch_file_idx": 1, "pos":[[3,6],       [1,9], [0,4]]},
	76: { "name": "E5",  "factor_idx": 7, "pitch_file_idx": 1, "pos":[[3,7],       [1,10],[0,5]]},
	77: { "name": "F5",  "factor_idx": 8, "pitch_file_idx": 1, "pos":[[3,8],       [1,11],[0,6]]},
	78: { "name": "F5#", "factor_idx": 9, "pitch_file_idx": 1, "pos":[[3,9],       [1,12],[0,7]]},
	79: { "name": "G5",  "factor_idx": 10, "pitch_file_idx": 1, "pos":[[3,10],             [0,8]]},
	80: { "name": "G5#", "factor_idx": 11, "pitch_file_idx": 1, "pos":[[3,11],             [0,9]]},
	81: { "name": "A5",  "factor_idx": 12, "pitch_file_idx": 1, "pos":[[3,12],             [0,1]]},
	82: { "name": "A5#", "factor_idx": 13, "pitch_file_idx": 1, "pos":                    [[0,11]]},
	83: { "name": "B5",  "factor_idx": 14, "pitch_file_idx": 1, "pos":                    [[0,12]]},
	84: { "name": "C5",  "factor_idx": 15, "pitch_file_idx": 1, "pos":                    [[0,13]]},
	85: { "name": "C5#", "factor_idx": 16, "pitch_file_idx": 1, "pos":                    [[0,14]]},
	86: { "name": "D6",  "factor_idx": 17, "pitch_file_idx": 1, "pos":                    [[0,15]]},
}

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

