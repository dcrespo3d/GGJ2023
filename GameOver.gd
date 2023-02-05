extends Control

var score = 0
var cacademons = 0
var slimes = 0
var rondasPuntos = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	score = get_tree().get_root().get_node("EscenaMain").score
	print(score)
	$Label.text = str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://EscenaMain.tscn")


func _on_BACK_TO_MENU_pressed():
	get_tree().change_scene("res://EscenaMainMenu.tscn")
