extends KinematicBody2D

export (PackedScene) var Projectile
export (PackedScene) var SFXDash
export (PackedScene) var SFXJump
export (PackedScene) var SFXHeal
export (PackedScene) var SFXDeath

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	ammo_current = ammo_max # Replace with function body.

export var walkspeed = 300
export var maxHealth = 10
export var currentHealth = 10
export var heal = 1
export var inmunity = false
export var ammo_max = 8
export var ammo_current = 8
export (float) var reloadspeed = 1

export var jumpspeed = -500
export var fallacc = 1000
var velocity = Vector2.ZERO
var isonfloor = false
		
export (int) var Dash_Speed2 = 1000
export var minDash_Speed2 = 250
export var dash_Duration2 = 70
export var mindash_Duration2 = 10
export var dashcooldown = 0.2
export var dashrecoveryspeed = 0.2
export var dashstalerate = 0.8

export var attackUpThreshold = -45
export var attackDownThreshold = 15
export var fallWhileAttacking = false
export var attackCooldown = 0.5

var tiempo = 0
var tiempo2 = 0
export var MAXtiempo = 3
var isbegginingsuck = false
var dashcool = 0
var landing = false
var dashlength = 20
var Dash_Speed2temp = 1000
var dashstale = 1
var lookleft = false
enum {NORMAL, SUCK, SHOOT, HIT, DEAD, JUMP, DASH, BUSY}
var state = NORMAL
var squatting = false
var blinking = true
var blinkingtimermax = 40
var blinkingtimer = 40

var prevState = NORMAL

var inDemo = true
var begDemo = true

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	
	
	if dashstale < 1:
		dashstale = dashstale + dashrecoveryspeed * delta
	if dashstale > 1:
		dashstale = 1
		
	if dashcool > 0:
		dashcool = dashcool - 1 * delta

	
	if Input.is_action_just_pressed("heal_key") && state == NORMAL:
		_takeHeal(delta, heal, reloadspeed)

	if inDemo && isonfloor:
		process_demo(delta)
	else:
		match (state):
			NORMAL: process_normal(delta)
			SUCK: process_suck(delta)
			SHOOT: process_shoot(delta)
			HIT: process_hit(delta)
			DEAD: process_dead(delta)
			JUMP: process_jump(delta)
			DASH: process_dash(delta, dash_Duration2)
			BUSY: process_busy(delta)
		
	if lookleft:
		$AnimatedSprite.flip_h = true
	
	else:
		$AnimatedSprite.flip_h = false

	velocity.y += fallacc * delta
	
	get_tree().get_root().get_node("EscenaMain/Gui/TextureRect5/Label").text = str(ammo_current) + "/" + str(ammo_max)
	get_tree().get_root().get_node("EscenaMain/Gui/TextureRect5/Label").add_color_override("font_color", Color(0,1,0))
	if ammo_current < ammo_max/2:
		get_tree().get_root().get_node("EscenaMain/Gui/TextureRect5/Label").add_color_override("font_color", Color(1,1,0))
	if ammo_current < ammo_max/4:
		if blinkingtimer <= 0:
			blinking = !blinking
			blinkingtimer = blinkingtimermax
		if blinking:
			get_tree().get_root().get_node("EscenaMain/Gui/TextureRect5/Label").add_color_override("font_color", Color(1,0,0))
		else:
			get_tree().get_root().get_node("EscenaMain/Gui/TextureRect5/Label").add_color_override("font_color", Color(1,1,0))
		blinkingtimer = blinkingtimer-1
		
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
		if ammo_current > 0:
			begin_shoot()
		else:
			shoot_fail()
	
		
	var oldyvelocity = velocity.y
	
	velocity = move_and_slide(velocity, Vector2.UP)
	isonfloor = oldyvelocity!=velocity.y
	
	if Input.is_action_just_pressed("dash_key"):
		dash(delta, dash_Duration2)
	
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
	
	if Input.is_action_pressed("heal_key") && !isbegginingsuck:
		$AnimatedSprite.animation = "Charge"
		_takeHeal(delta, heal, reloadspeed)

	if !Input.is_action_pressed("heal_key") && !isbegginingsuck:
		$AnimatedSprite.animation = "Charge_Out"
		if $AnimatedSprite.frame == 5:
			state = NORMAL
			if sfx_heal != null:
				sfx_heal.queue_free()
				sfx_heal = null
		tiempo = 0
		tiempo2 = 0
	
	return

func process_shoot(delta):
	if $AnimatedSprite.frame == 3:
		if projectile == null:
			ammo_current = ammo_current - 1
			instance_projectile()
	elif $AnimatedSprite.frame == 7:
		state = NORMAL
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
	get_tree().get_root().get_node("EscenaMain/Viewport/GameOver").visible = true
	get_tree().get_root().get_node("EscenaMain/Gui").visible = false
	velocity.x = 0
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
		dash(delta, dash_Duration2)
		
	
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
		if ammo_current > 0:
			begin_shoot()
		else:
			shoot_fail()

	return

func process_dash(delta, dash_Duration2):
	$AnimatedSprite.animation = "Dash"
	dashlength = dashlength-1
	if dashlength > 0:
		if lookleft:
			velocity.x = -Dash_Speed2temp
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
		else:
			velocity.x = Dash_Speed2temp
			velocity = move_and_slide(velocity, Vector2.UP)
			dashlength = dashlength - 1
	else:
		dashlength = dash_Duration2
		state = NORMAL
		dashcool = dashcooldown
		
	return
	
func process_busy(delta):
	var length = $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation)
	if $AnimatedSprite.frame == length-1:
		state = NORMAL
		
		
func process_demo(delta):
	if currentHealth < maxHealth or ammo_current < ammo_max and inDemo:
		_takeHeal(delta, heal, reloadspeed)
	else:
		if !isbegginingsuck:
			begDemo = false
			$AnimatedSprite.animation = "Charge_Out"
			if $AnimatedSprite.frame == 5:
				state = NORMAL
				inDemo = false
				if sfx_heal != null:
					sfx_heal.queue_free()
					sfx_heal = null
				tiempo = 0
				tiempo2 = 0
		
		state = NORMAL
		
	if isbegginingsuck and sfx_heal == null and SFXHeal != null and begDemo:
		sfx_heal = SFXHeal.instance()
		add_child(sfx_heal)

	if $AnimatedSprite.animation == "Charge_Enter" && $AnimatedSprite.frame == 6 and begDemo:
		isbegginingsuck = false
	
	if !isbegginingsuck and begDemo:
		$AnimatedSprite.animation = "Charge"
		_takeHeal(delta, heal, reloadspeed)

	
	return

func dash(delta, dash_Duration2):
	if dashcool <= 0:
		dashlength = dash_Duration2 # * dashstale
		Dash_Speed2temp = Dash_Speed2 * dashstale
		if dashlength < mindash_Duration2:
			dashlength = mindash_Duration2
		
		dashstale = dashstale * dashstalerate
		state = DASH
		if SFXDash != null:
			add_child(SFXDash.instance())
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
	if proj_tilt_angle < attackUpThreshold:
		$AnimatedSprite.animation = "Attack_Up"
	elif proj_tilt_angle < attackDownThreshold:
		$AnimatedSprite.animation = "Attack_Horizontal"
	else:
		$AnimatedSprite.animation = "Attack_Down"
		
	$AnimatedSprite.flip_h = lookleft

	projectile = null
	
func shoot_fail():
	$AnimatedSprite.animation= "No Ammo"
	state = BUSY
	

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
		if SFXDeath != null:
			add_child(SFXDeath.instance())

		
		
func _takeHeal(delta, heal, reloadspeed):
	if currentHealth < maxHealth && isonfloor:
		_on_Timer_timeout(delta)
		currentHealth += heal * tiempo
		if tiempo == MAXtiempo: 
			currentHealth += heal * MAXtiempo
		get_tree().get_root().get_node("EscenaMain/Viewport/Gea")._takeHit(heal)

	if ammo_current < ammo_max && isonfloor:
		tiempo2func(delta)
		if tiempo2 > 1/reloadspeed:
			ammo_current += 1
			tiempo2 = 0
	
	
	if state != SUCK && isonfloor:
		$AnimatedSprite.animation = "Charge_Enter"
		isbegginingsuck = true
		state = SUCK

func getType():
	return  "Player"


func _on_Timer_timeout(delta):
	tiempo += 1 * delta 
func tiempo2func(delta):
	tiempo2 += 1 * delta 
