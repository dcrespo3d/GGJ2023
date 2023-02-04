extends KinematicBody2D

export (PackedScene) var Projectile
export (PackedScene) var SFXDash
export (PackedScene) var SFXJump
export (PackedScene) var SFXHeal

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var walkspeed = 300
export var maxHealth = 10
export var currentHealth = 10
export var heal = 1
export var inmunity = false


export var jumpspeed = -500
export var fallacc = 1000
var velocity = Vector2.ZERO
var isonfloor = false
		
export (int) var dash_Speed = 1000
export var minDash_Speed = 250
export var dash_Duration = 70
export var mindash_Duration = 10
export var dashcooldown = 0.2
export var dashrecoveryspeed = 0.2
export var dashstalerate = 0.8

export var attackUpThreshold = -45
export var attackDownThreshold = 15
export var fallWhileAttacking = false
export var attackCooldown = 0.5


var isbegginingsuck = false
var dashcool = 0
var landing = false
var dashlength = 20
var dash_Speedtemp = 1000
var dashstale = 1
var lookleft = false
enum {NORMAL, SUCK, SHOOT, HIT, DEAD, JUMP, DASH}
var state = NORMAL
var squatting = false

var prevState = NORMAL

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
		_takeHeal(delta, heal)
	if Input.is_action_pressed("debug3"):
		state = SHOOT
		print("shoot")
	if Input.is_action_just_pressed("debug4"):
		_takeHit(50)
		print(currentHealth)

	if Input.is_action_pressed("debug5"):
		state = DEAD
		print("dead")
		
	if Input.is_action_just_pressed("debug6"):
		
		_takeHit(10)

	match (state):
		NORMAL: process_normal(delta)
		SUCK: process_suck(delta)
		SHOOT: process_shoot(delta)
		HIT: process_hit(delta)
		DEAD: process_dead(delta)
		JUMP: process_jump(delta)
		DASH: process_dash(delta, dash_Duration)
		
	if lookleft:
		$AnimatedSprite.flip_h = true
	
	else:
		$AnimatedSprite.flip_h = false

	velocity.y += fallacc * delta
	
#	print("STATE: ", state)
	
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
	
	if Input.is_action_just_pressed("shoot"):
		begin_shoot()
	
		
	var oldyvelocity = velocity.y
	
	velocity = move_and_slide(velocity, Vector2.UP)
	isonfloor = oldyvelocity!=velocity.y
	
	if Input.is_action_just_pressed("dash_key"):
		dash(delta, dash_Duration)
	
	if velocity.y != 0:
		state = JUMP
	
	return

var sfx_heal = null;
	
func process_suck(delta):
	if isbegginingsuck and sfx_heal == null and SFXHeal != null:
		sfx_heal = SFXHeal.instance()
		add_child(sfx_heal)

	if $AnimatedSprite.animation == "Charge_Enter" && $AnimatedSprite.frame == 6:
		isbegginingsuck = false
	
	if Input.is_action_pressed("debug2") && !isbegginingsuck:
		$AnimatedSprite.animation = "Charge"
		_takeHeal(delta, heal)
		print("heal 1")

	if !Input.is_action_pressed("debug2") && !isbegginingsuck:
		$AnimatedSprite.animation = "Charge_Out"
		if $AnimatedSprite.frame == 5:
			state = NORMAL
			if sfx_heal != null:
				sfx_heal.queue_free()
				sfx_heal = null
			
	
	return

func process_shoot(delta):
	if $AnimatedSprite.frame == 3:
		if projectile == null:
			instance_projectile()
	elif $AnimatedSprite.frame == 7:
		state = NORMAL
#	print("$AnimatedSprite.animation:", $AnimatedSprite.animation)
#	print("$AnimatedSprite.frame:", $AnimatedSprite.frame)
	if fallWhileAttacking and prevState == JUMP:
		var oldyvelocity = velocity.y
		velocity = move_and_slide(velocity, Vector2.UP)
		isonfloor = oldyvelocity != velocity.y

func process_hit(delta):
	if $AnimatedSprite.frame == 5:
		state = NORMAL
	return
	
func process_dead(delta):
	$AnimatedSprite.animation = "Die"
	velocity = move_and_slide(velocity, Vector2.UP)
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
		dash(delta, dash_Duration)
		
	
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
		
	if Input.is_action_just_pressed("shoot"):
		begin_shoot()


	return

func process_dash(delta, dash_Duration):
	$AnimatedSprite.animation = "Dash"
	dashlength = dashlength-1
	if dashlength > 0:
		if lookleft:
			velocity.x = -dash_Speedtemp
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
		else:
			velocity.x = dash_Speedtemp
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
	else:
		dashlength = dash_Duration
		state = NORMAL
		dashcool = dashcooldown
		
	return

func dash(delta, dash_Duration):
	if dashcool <= 0:
		dashlength = dash_Duration # * dashstale
		dash_Speedtemp = dash_Speed * dashstale
		if dashlength < mindash_Duration:
			dashlength = mindash_Duration
		
		dashstale = dashstale * dashstalerate
		state = DASH
		if SFXDash != null:
			add_child(SFXDash.instance())
		print(dashlength)
	return

func jump(delta):
	velocity.y = jumpspeed
	velocity = move_and_slide(velocity, Vector2.UP)
	state = JUMP
	$AnimatedSprite.animation = "Jump_Enter"
	if SFXJump != null:
		add_child(SFXJump.instance())
	return
	
func _on_AnimatedSprite_animation_finished():
	landing = false

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation != "Jump_Out":
		landing = false
	


var mousePos = Vector2.ZERO

var projectile = null

func begin_shoot():
	prevState = state
	state = SHOOT
	
	var direction = (mousePos - position).normalized()
	var proj_tilt_angle = rad2deg(direction.angle());

	if   proj_tilt_angle < -90:
		lookleft = true
		proj_tilt_angle = -90 - (proj_tilt_angle + 90)
	elif proj_tilt_angle >  90:
		lookleft = true
		proj_tilt_angle =  90 - (proj_tilt_angle - 90)
	else:
		lookleft = false
#	print("projectile.rotation:", proj_tilt_angle)
	if proj_tilt_angle < attackUpThreshold:
		$AnimatedSprite.animation = "Attack_Up"
		print("attack_up")
	elif proj_tilt_angle < attackDownThreshold:
		$AnimatedSprite.animation = "Attack_Horizontal"
		print("attack_horiz")
	else:
		$AnimatedSprite.animation = "Attack_Down"
		print("attack_down")
		
	$AnimatedSprite.flip_h = lookleft

	projectile = null
	
func instance_projectile():
	projectile = Projectile.instance()
	projectile.position = position
	
	var direction = (mousePos - position).normalized()
	projectile.velocity = direction * projectile.scalarSpeed
	projectile.rotation = direction.angle()
	
	get_tree().get_root().get_node("EscenaMain/Viewport").add_child(projectile)


	
func _takeHit(damage):
	if currentHealth > 0:
		currentHealth -= damage
		if !$AnimatedSprite.animation == "Charge" && !$AnimatedSprite.animation == "Charge_Enter" :
			state = HIT
			$AnimatedSprite.animation = "Hit"
	if currentHealth <= 0:
		currentHealth = -1
		state = DEAD
		
		
func _takeHeal(delta, heal):
	if currentHealth < maxHealth && isonfloor:
		currentHealth += heal
		get_tree().get_root().get_node("EscenaMain/Viewport/Gea")._takeHit(heal)

	if state != SUCK && isonfloor:
		$AnimatedSprite.animation = "Charge_Enter"
		isbegginingsuck = true
		state = SUCK

func getType():
	return  "Player"
