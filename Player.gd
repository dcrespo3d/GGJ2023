extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var walkspeed = 300
export var dashspeed = 60
export var jumpspeed = -500
export var fallacc = 1000
var velocity = Vector2.ZERO	
		


export var dashduration = 20
var dashstale = 1
var lookleft = false
enum {NORMAL, SUCK, BUSY, HIT, DEAD, JUMP}
var state = NORMAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if Input.is_action_pressed("debug1"):
		state = NORMAL
		print("normal")
	if Input.is_action_pressed("debug2"):
		state = SUCK
		print("suck")
	if Input.is_action_pressed("debug3"):
		state = BUSY
		print("busy")
	if Input.is_action_pressed("debug4"):
		state = HIT
		print("hit")
	if Input.is_action_pressed("debug5"):
		state = DEAD
		print("dead")

	match (state):
		NORMAL: process_normal(delta)
		SUCK: process_suck(delta)
		BUSY: process_busy(delta)
		HIT: process_hit(delta)
		DEAD: process_dead(delta)
		JUMP: process_jump(delta)
		
func process_normal(delta):
	velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x = -walkspeed
		lookleft = true
	if Input.is_action_pressed("ui_right"):
		velocity.x = walkspeed
		lookleft = false
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = jumpspeed
		
	velocity.y += fallacc * delta
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	return
	
func process_suck(delta):
	return
	

func process_busy(delta):
	return
	
func process_hit(delta):
	return
	
func process_dead(delta):
	return

func process_jump(delta):
	return


func dash(delta):
	state = BUSY
	var dashlength = dashduration
	if lookleft:
		while (dashlength * dashstale > 0):
			velocity.x = -walkspeed
			dashlength = dashlength - 1
	else:
		while (dashlength * dashstale > 0):
			velocity.x = walkspeed
			dashlength = dashlength - 1
	state = NORMAL
	return
