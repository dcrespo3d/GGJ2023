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
	if Input.is_action_pressed("debug1"):
		state = NORMAL
	if Input.is_action_pressed("debug2"):
		state = SUCK
	if Input.is_action_pressed("debug3"):
		state = BUSY
	if Input.is_action_pressed("debug4"):
		state = HIT
	if Input.is_action_pressed("debug5"):
		state = DEAD

	
	match (state):
		NORMAL: process_normal()
		SUCK: process_suck()
		BUSY: process_busy()
		HIT: process_hit()
		DEAD: process_dead()
		
		
func process_normal():
	print("normal")
	return
	
func process_suck():
	print("suck")
	return
	

func process_busy():
	print("busy")
	return
	
func process_hit():
	print("hit")
	return
	
func process_dead():
	print("dead")
	return

