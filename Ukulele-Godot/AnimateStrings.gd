extends AnimationPlayer

@onready var game_root_node = $/root/Node3D
@onready var ukulele_node = $/root/Node3D/Ukulele

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

	



func _on_play(v, _stop = false):
	print("_on_play: " + str(v))
	var s
	var note = ""
	if v == 1:
		s = "String-1"
		note = "A"
	elif v == 2:
		s = "String-2"
		note = "B"
	elif v == 3:
		s = "String-3"
		note = "C#"
	elif v == 4:
		s = "String-4"
		note = "D"
	else:
		print("wrong node")
		return
	if _stop == true:
		stop()
	else:
		play(s)
		play_note(note)
	

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

func play_note(n):
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = preload("res://tunes/ukulele_la.440.wav")
	audio.pitch_scale = _notes_factors[_notes_names[n]]
	audio.play()
	#color_timer.start()
	await get_tree().create_timer(8.0).timeout
	audio.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

