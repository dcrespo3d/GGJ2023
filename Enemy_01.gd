extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 100
var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y = speed
	velocity = move_and_slide(velocity, Vector2.UP)
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
