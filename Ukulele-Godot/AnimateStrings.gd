extends AnimationPlayer

@onready var game_root_node = $/root/Node3D
@onready var ukulele_node = $/root/Node3D/Ukulele

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

