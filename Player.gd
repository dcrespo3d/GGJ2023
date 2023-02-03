extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var walkspeed = 30
export var dashspeed = 60
var lookleft = false
enum {NORMAL, SUCK, BUSY, HIT, DEAD}
var state = NORMAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

	match (state):
		NORMAL: process_normal()
		SUCK: process_suck()
		BUSY: process_busy()
		HIT: process_hit()
		DEAD: process_dead()
		
		
func process_normal():
	return
	
func process_suck():
	return
	

func process_busy():
	return
	
func process_hit():
	return
	
func process_dead():
	return

