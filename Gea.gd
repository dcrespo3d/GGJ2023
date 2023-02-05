extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum {NORMAL, SUCK, SHOOT, HIT, DEAD, JUMP, DASH}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
export var maxHealth = 10
export (float) var currentHealth = 10
func getType():
	return  "Gea"
func _takeHit(damage):
	if currentHealth > 0:
		currentHealth -= damage	
func _takeHeal(heal):
	if currentHealth < maxHealth :
		currentHealth += heal
	if currentHealth < maxHealth:
		currentHealth == maxHealth
func _process(delta):
	if currentHealth <= 0:
		get_tree().get_root().get_node("EscenaMain/Viewport/GameOver").visible=true
		get_tree().get_root().get_node("EscenaMain/Viewport/Player").state = DEAD
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

