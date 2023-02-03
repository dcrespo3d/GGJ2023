extends Node2D


export var scaleFactorX = 3
export var scaleFactorY = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mousePos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouseRawPos = get_viewport().get_mouse_position()
	mousePos.x = mouseRawPos.x / scaleFactorX
	mousePos.y = mouseRawPos.y / scaleFactorY
	position = mousePos
