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
]

var _notes_names = [
	"A",
	"A#",
	"B",
	"C",
	"C#",
	"D",
	"D#",
	"E",
	"F",
	"F#",
	"G",
	"G#"
]

	



func _on_play(v, _stop = false):
	print("_on_play: " + str(v))
	var s
	if v == 1:
		s = "String-1"
	elif v == 2:
		s = "String-2"
	elif v == 3:
		s = "String-3"
	elif v == 4:
		s = "String-4"
	else:
		print("wrong node")
		return
	if _stop == true:
		stop()
	else:
		play(s)
	

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



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

