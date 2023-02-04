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


export var jumpspeed = -500
export var fallacc = 1000
var velocity = Vector2.ZERO
var isonfloor = false
		
export var dashspeed = 1000
export var mindashspeed = 250
export var dashduration = 70
export var mindashduration = 10
export var dashcooldown = 0.2
export var dashrecoveryspeed = 0.2
export var dashstalerate = 0.8


var dashcool = 0
var landing = false
var dashlength = 20
var dashspeedtemp = 1000
var dashstale = 1
var lookleft = false
enum {NORMAL, SUCK, BUSY, HIT, DEAD, JUMP, DASH}
var state = NORMAL
var squatting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	if dashstale < 1:
		dashstale = dashstale + dashrecoveryspeed * delta
	if dashstale > 1:
		dashstale = 1
		
	if dashcool > 0:
		dashcool = dashcool - 1 * delta

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
		
	if Input.is_action_just_pressed("shoot"):
		perform_shoot()

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
	
	print(dashstale)
	
	
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
			velocity.x = -dashspeedtemp
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
		else:
			velocity.x = dashspeedtemp
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
	else:
		dashlength = dashduration
		state = NORMAL
		dashcool = dashcooldown
		
	return

func dash(delta, dashduration):
	if dashcool <= 0:
		dashlength = dashduration # * dashstale
		dashspeedtemp = dashspeed * dashstale
		if dashlength < mindashduration:
			dashlength = mindashduration
		
		dashstale = dashstale * dashstalerate
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
	


var mousePos = Vector2.ZERO

func perform_shoot():
	var projectile = Projectile.instance()
	projectile.position = position
	
	var direction = (mousePos - position).normalized()
	projectile.velocity = direction * projectile.scalarSpeed
	projectile.rotation = direction.angle()
	
	get_tree().get_root().get_node("EscenaMain/Viewport").add_child(projectile)
