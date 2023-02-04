extends KinematicBody2D

export (PackedScene) var Projectile

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var walkspeed = 300
export var maxHealth = 10
export var currentHealth = 10
export var inmunity = false
export var dashspeed = 1000
export var jumpspeed = -500
export var fallacc = 1000
var velocity = Vector2.ZERO
var isonfloor = false
		
export var dashrecoveryspeed = 0.001
export var dashduration = 70
export var dashcooldown = 50
export var mindashduration = 10
var dashcool = 0
var landing = false
var dashlength = 20
var dashstale = 1
var lookleft = false
enum {NORMAL, SUCK, BUSY, HIT, DEAD, JUMP, DASH}
var state = NORMAL
var squatting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	if dashstale < 1:
		dashstale = dashstale + dashrecoveryspeed
		
	if dashcool > 0:
		dashcool = dashcool - 1

	if Input.is_action_just_pressed("debug1"):
		state = NORMAL
		print("normal")
	if Input.is_action_just_pressed("debug2"):
		state = SUCK
		print("suck")
	if Input.is_action_pressed("debug3"):
		state = BUSY
		print("busy")
	if Input.is_action_just_pressed("debug4"):
		currentHealth -= 10
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
	
	print(landing)
	
	
	#print(isonfloor)
	
	#print(get_viewport().get_mouse_position())
		
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
		jump(delta)
		
		
	if velocity.x == 0 && !landing && isonfloor:
		$AnimatedSprite.animation = "Idle"
	
	
		
	var oldyvelocity = velocity.y
	
	velocity = move_and_slide(velocity, Vector2.UP)
	isonfloor = oldyvelocity!=velocity.y
	
	if Input.is_action_just_pressed("dash_key"):
		dash(delta, dashduration)
	
	if velocity.y != 0:
		state = JUMP
	
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
	var oldyvelocity = velocity.y
	
	
	velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x = -walkspeed
		lookleft = true
	if Input.is_action_pressed("ui_right"):
		velocity.x = walkspeed
		lookleft = false
	if Input.is_action_just_pressed("dash_key"):
		dash(delta, dashduration)
	
	if velocity.y > 0:
		$AnimatedSprite.animation = "Jump_Down"
	if velocity.y < 0:
		$AnimatedSprite.animation = "Jump_Up"
	
	velocity = move_and_slide(velocity, Vector2.UP)
	isonfloor = oldyvelocity!=velocity.y
	
	if isonfloor:
		$AnimatedSprite.animation = "Jump_Out"
		state = NORMAL
		landing = true
		
	

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
		dashcool = dashcooldown
	return

func dash(delta, dashduration):
	if dashcool <= 0:
		dashlength = dashduration * dashstale
		if dashlength < mindashduration:
			dashlength = mindashduration
		dashstale = dashstale * 0.8
		state = DASH
	return

func jump(delta):
	velocity.y = jumpspeed
	velocity = move_and_slide(velocity, Vector2.UP)
	state = JUMP
	$AnimatedSprite.animation = "Jump_Enter"
	return
	
func _on_AnimatedSprite_animation_finished():
	landing = false

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation != "Jump_Out":
		landing = false
	
