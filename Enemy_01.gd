extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 100
var velocity = Vector2.ZERO
enum {IDLE, ATTACK, HIT, DIE}
var state = IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	match (state):
		IDLE: process_idle(delta)
		ATTACK: process_attack(delta)
		HIT: process_hit(delta)
		DIE: process_die(delta)
	return

func process_idle(delta):
	
	velocity.y = speed
	velocity = move_and_slide(velocity, Vector2.UP)

func process_attack(delta):
	return
	
func process_hit(delta):
	return
	
func process_die(delta):
	return
# La funcion de daño del player se llama _takeHit
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	pass # Replace with function body.
