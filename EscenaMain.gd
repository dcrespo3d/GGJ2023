extends Node2D

export(PackedScene) var Enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var spawntimer = 2
export var speedincrease = 0.9
var actualtimer = 2
func _ready():
	pass


# Called when the node enters the scene tree for the first time.
func _spawnEnemy():
	var enemy = Enemy.instance()
	var enemy_spawn_location = get_node("Viewport/enemyPath/enemySpawn")
	enemy_spawn_location.unit_offset = randf()
	var direction = enemy_spawn_location.rotation + PI / 2
	enemy.position = enemy_spawn_location.position
	print(enemy_spawn_location.unit_offset)
	print(enemy_spawn_location.position)
	
	
	$Viewport.add_child(enemy)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actualtimer = actualtimer - 1*delta
	print(spawntimer)
	if Input.is_action_just_pressed("debug1"):
		_spawnEnemy()
		
	if actualtimer <= 0:
		spawntimer = spawntimer * speedincrease
		actualtimer = spawntimer
		_spawnEnemy()
	
	
#func _on_Timer_timeout():
#	_spawnEnemy()


	$Gui/TextureRect.rect_size.x = $Viewport/Player.currentHealth
	$Gui/TextureRect2.rect_size.x = $Viewport/Gea.currentHealth
	
	# sistema de disparo
	$Viewport/Player.mousePos = $Viewport/Target.mousePos
	

