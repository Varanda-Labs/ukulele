extends AnimationPlayer

enum { ST_JUST_LOAD,
 ST_WAIT_START,
 ST_PLAYING_1,
 ST_PLAYING_2,
 ST_PLAYING_3,
 ST_PLAYING_4,
 ST_PLAYING_ALL,
 ST_WAIT_USER_INPUT }

@onready var game_root_node = $/root/Node3D
@onready var ukulele_node = $/root/Node3D/Ukulele

var state = ST_JUST_LOAD
var time_ref = -1
var acc = 0

const DELAY_1 = 1

func _on_play_old(v):
	print("_on_play: " + v)
	if self.name == "AnimationPlayer_1":
		play("String-1")
	elif self.name == "AnimationPlayer_2":
		play("String-2")
	elif self.name == "AnimationPlayer_3":
		play("String-3")
	elif self.name == "AnimationPlayer_4":
		play("String-4")
	else:
		print("wrong node")

func _on_play(v):
	print("_on_play: " + str(v))
	if v == 1:
		play("String-1")
	elif v == 2:
		play("String-2")
	elif v == 3:
		play("String-3")
	elif v == 4:
		play("String-4")
	else:
		print("wrong node")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name == "AnimationPlayer_1":
		game_root_node.play_string_1_requested.connect(_on_play)
	elif self.name == "AnimationPlayer_2":
		game_root_node.play_string_2_requested.connect(_on_play)
	elif self.name == "AnimationPlayer_3":
		game_root_node.play_string_3_requested.connect(_on_play)
	elif self.name == "AnimationPlayer_4":
		game_root_node.play_string_4_requested.connect(_on_play)

		return
	return
	
	speed_scale = 1
	print("name: " + self.name)
	#print("Play Anim 4")
	#play("String-4")
	if self.name == "AnimationPlayer":
		play("String-1")
	else:
		play("String-2")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
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
			play("String-1")
			state = ST_PLAYING_1
			
	elif state == ST_PLAYING_1:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim 2")
			play("String-2")
			state = ST_PLAYING_2
			
	elif state == ST_PLAYING_2:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim 3")
			play("String-3")
			state = ST_PLAYING_3
			
	elif state == ST_PLAYING_3:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim 4")
			play("String-4")
			state = ST_PLAYING_4
			
	elif state == ST_PLAYING_4:
		if acc > time_ref + DELAY_1:
			time_ref = 0
			acc = 0
			print("Play Anim All")
			stop()
			play("String-1")
			play("String-2")
			play("String-3")
			play("String-4")
			state = ST_PLAYING_ALL
			
	elif state == ST_PLAYING_ALL:
		if acc > time_ref + DELAY_1:
			time_ref = acc
			print("Done")
			state = ST_WAIT_USER_INPUT
