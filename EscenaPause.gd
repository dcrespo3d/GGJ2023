extends Node

func _input(event: InputEvent):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		$Popup.visible = not $Popup.visible


func _on_Start_pressed():
	get_tree().paused = not get_tree().paused
	$Popup.visible = not $Popup.visible
	
func _on_BACK_TO_MENU_pressed():
	get_tree().paused = false
	var err = get_tree().change_scene("res://EscenaMainMenu.tscn")
#	print("_on_BACK_TO_MENU_pressed:", err)
	
	
func _on_Exit_pressed():
	get_tree().quit()



func _on_Resume_pressed():
	_on_Start_pressed()


func _on_Quit_pressed():
	_on_Exit_pressed()


func _on_MainMenu_pressed():
	_on_BACK_TO_MENU_pressed()
