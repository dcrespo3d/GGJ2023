extends Node2D

export(PackedScene) var Enemy1
export(PackedScene) var Enemy2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var tiempo = 0
export var tiempo2 = 0
export var tiempo3 = 0
export var rounds = 1
export (float) var spawntimer = 2
export var speedincrease = 0.01
var actualtimer = 2


#Oleadas_variables
var bichosmuertos = 0
var rondas = 0
var bichosPorRonda = 10
var tiempoPorRonda = 6.67
var bichosIniciales = 15
var tiempoInicial = 12
var actualEnemy2InRound = 0
var maxEnemy2InRound = 0
var enemyKindSpawnDecider = 0

var primeraRonda = true
var bichosronda = 0
var tiemporonda = 0
var playerAlive = true
enum {NORMAL, SUCK, SHOOT, HIT, DEAD, JUMP, DASH, BUSY} 

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
	_on_Timer_timeout(delta)
	actualtimer = actualtimer - 1*delta
#	print(spawntimer)
	if Input.is_action_just_pressed("debug1"):
		_spawnEnemy2()
		_spawnEnemy1()
	#print (actualtimer)
	
	if tiempo3 >= 2:
		if get_tree().get_root().get_node("EscenaMain/Viewport/Player").state == DEAD:
			playerAlive = false
	
	
	if playerAlive :
		
		if tiemporonda == 0 || bichosronda == 0:
			_inicioRonda()
		
		if tiempo >= 1:
			tiemporonda -= 1
			tiempo = 0
			
			# Se llega al spawn de un nuevo enemigo
		if tiempo2 >= spawntimer && bichosronda != 0:
			
			if actualEnemy2InRound < maxEnemy2InRound:
				print(actualEnemy2InRound, "<", maxEnemy2InRound)
				enemyKindSpawnDecider = randi()%2
				if enemyKindSpawnDecider == 1:
					_spawnEnemy1()
				else:
					_spawnEnemy2()
					actualEnemy2InRound += 1
			else:
				_spawnEnemy1()
			bichosronda -= 1
			print("Bichos ronda restantes: ", bichosronda)
			tiempo2 = 0
		
	
	

	$Gui/TextureRect.rect_size.x = $Viewport/Player.currentHealth
	$Gui/TextureRect2.rect_size.x = $Viewport/Gea.currentHealth
	
	# sistema de disparo
	$Viewport/Player.mousePos = $Viewport/Target.mousePos
	

func _inicioRonda():
	if primeraRonda == true:
		primeraRonda = false
	else:
		rondas += 1
	
	
	bichosronda = bichosIniciales + bichosPorRonda * rondas
	tiemporonda = tiempoInicial + tiempoPorRonda * rondas
	spawntimer = tiemporonda/bichosronda
	
	actualEnemy2InRound = 0
	maxEnemy2InRound = rondas
	
	print("bichos: ", bichosronda)
	print("tiempo nueva ronda gente :D : ", tiemporonda)
	print("spawntimer: ", spawntimer)


func _on_Timer_timeout(delta):
	tiempo += 1 * delta
	tiempo2 += 1 * delta	
	tiempo3 += 1 * delta
