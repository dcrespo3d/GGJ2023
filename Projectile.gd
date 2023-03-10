extends KinematicBody2D

export var scalarSpeed = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	print("projectile removed")
func getType():
	return  "Projectile"
