extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var walkspeed = 300
export var dashspeed = 1000
export var jumpspeed = -500
export var fallacc = 1000
var velocity = Vector2.ZERO	
var isonfloor = false
		
export var dashrecoveryspeed = 0.001
export var dashduration = 70
var dashlength = 20
var dashstale = 1
var lookleft = false
enum {NORMAL, SUCK, BUSY, HIT, DEAD, JUMP, DASH}
var state = NORMAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dashstale < 1:
		dashstale = dashstale + dashrecoveryspeed

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
		DASH: process_dash(delta, dashduration)
		
	if lookleft:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		
	velocity.y += fallacc * delta
		
func process_normal(delta):
	
	velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x = -walkspeed
		lookleft = true
		$AnimatedSprite.animation = "Run"
	if Input.is_action_pressed("ui_right"):
		velocity.x = walkspeed
		lookleft = false
		$AnimatedSprite.animation = "Run"
	if Input.is_action_just_pressed("ui_up") && isonfloor:
		velocity.y = jumpspeed
	
	if velocity.x == 0:
		$AnimatedSprite.animation = "Idle"
	
		
	var oldvelocity = velocity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	isonfloor = oldvelocity!=velocity
	
	if Input.is_action_just_pressed("dash_key"):
		dash(delta, dashduration)
	
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

func process_dash(delta, dashduration):
	$AnimatedSprite.animation = "Dash"
	dashlength = dashlength-1
	if dashlength > 0:
		if lookleft:
			velocity.x = -dashspeed
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
		else:
			velocity.x = dashspeed
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
	else:
		dashlength = dashduration
		state = NORMAL
	return

func dash(delta, dashduration):
	dashlength = dashduration * dashstale
	dashstale = dashstale * 0.8
	state = DASH
	return
