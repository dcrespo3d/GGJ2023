extends Node2D

export(PackedScene) var Enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy = Enemy.instance()
	enemy.position = Vector2(40,40)
	
	
	$Viewport.add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	$Gui/hpplayer.value = $Viewport/Player.currentHealth
	$Gui/hpplayer.max_value = $Viewport/Player.maxHealth
	$Gui/TextureRect.rect_size.x = $Viewport/Player.currentHealth
	$Gui/TextureRect2.rect_size.x = $Viewport/Gea.currentHealth

