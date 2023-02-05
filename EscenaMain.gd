extends Node2D

export(PackedScene) var Enemy1
export(PackedScene) var Enemy2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var spawntimer = 2
export var speedincrease = 0.01
var actualtimer = 2
func _ready():
	pass



# Called when the node enters the scene tree for the first time.
func _spawnEnemy1():
	var enemy = Enemy1.instance()
	var enemy_spawn_location = get_node("Viewport/enemyPath/enemySpawn")
	enemy_spawn_location.unit_offset = randf()
	var direction = enemy_spawn_location.rotation + PI / 2
	enemy.position = enemy_spawn_location.position
	#print(enemy_spawn_location.unit_offset)
	#print(enemy_spawn_location.position)
	
	
	
	
	$Viewport.add_child(enemy)
	
func _spawnEnemy2():
	var enemy2 = Enemy2.instance()
	var enemy2_spawn_location = get_node("Viewport/enemyPath2/enemySpawn2")
	enemy2_spawn_location.unit_offset = randi()%2
	var direction2 = enemy2_spawn_location.rotation + PI / 2
	enemy2.position = enemy2_spawn_location.position
	#print(enemy2_spawn_location.unit_offset)
	#print(enemy2_spawn_location.position)
	
	
	
	
	$Viewport.add_child(enemy2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actualtimer = actualtimer - 1*delta
#	print(spawntimer)
	if Input.is_action_just_pressed("debug1"):
		_spawnEnemy2()
		_spawnEnemy1()
		
		
	if actualtimer <= 0:
		spawntimer = spawntimer - spawntimer*speedincrease
		actualtimer = spawntimer
		_spawnEnemy1()
		_spawnEnemy2()
	

	$Gui/TextureRect.rect_size.x = $Viewport/Player.currentHealth
	$Gui/TextureRect2.rect_size.x = $Viewport/Gea.currentHealth
	
	# sistema de disparo
	$Viewport/Player.mousePos = $Viewport/Target.mousePos
	

