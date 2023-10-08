extends AnimationPlayer

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

const DELAY_1 = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	speed_scale = 1
	print("Play Anim 4")
	play("String-4")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acc = acc + delta
	if  state == ST_JUST_LOAD:
		time_ref = acc
		state = ST_WAIT_START
		
	elif state == ST_WAIT_START:
		if acc > time_ref + DELAY_1:
			time_ref = acc
			print("Play Anim 1")
			play("String-1")
			state = ST_PLAYING_1
			
	elif state == ST_PLAYING_1:
		if acc > time_ref + DELAY_1:
			time_ref = acc
			print("Play Anim 2")
			play("String-2")
			state = ST_PLAYING_2

	elif state == ST_PLAYING_2:
		if acc > time_ref + DELAY_1:
			time_ref = acc
			print("Done")
			state = ST_WAIT_USER_INPUT
