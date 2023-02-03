extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var walkspeed = 30
export var dashspeed = 60
export var dashduration = 20
var dashstale = 1
var lookleft = false
enum {NORMAL, SUCK, BUSY, HIT, DEAD}
var state = NORMAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match (state):
		NORMAL: process_normal(delta)
		SUCK: process_suck(delta)
		BUSY: process_busy(delta)
		HIT: process_hit(delta)
		DEAD: process_dead(delta)
		
	dashstale = dashstale + 0.001
		
func process_normal(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= walkspeed * delta
		lookleft = true
	if Input.is_action_pressed("ui_right"):
		position.x += walkspeed * delta
		lookleft = false
	if Input.is_action_pressed("ui_up"):
		position.y -= walkspeed * delta
	if Input.is_action_pressed("ui_down"):
		position.y += walkspeed * delta
	
	if Input.is_action_just_released("dash_key"):
			dash(delta)
	
func process_suck(delta):
	return
	
func process_busy(delta):
	return
	
func process_hit(delta):
	return
	
func process_dead(delta):
	return


func dash(delta):
	state = BUSY
	var dashlength = dashduration
	if lookleft:
		while (dashlength * dashstale > 0):
			position.x -= dashspeed * delta
			dashlength = dashlength - 1
	else:
		while (dashlength * dashstale > 0):
			position.x += dashspeed * delta
			dashlength = dashlength - 1
	state = NORMAL
	return
