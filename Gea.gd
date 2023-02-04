extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
export var maxHealth = 10
export var currentHealth = 10
func getType():
	return  "Gea"
func _takeHit(damage):
	if currentHealth > 0:
		currentHealth -= damage	
func _process(delta):
	if currentHealth <= 0:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

