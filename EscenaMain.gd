extends Node2D

export(PackedScene) var Enemy1
export(PackedScene) var Enemy2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var tiempo = 0
export var tiempo2 = 0
export var tiempo3 = 0
var tiempo4 = 0
var tiempo5 = 0

#Para cambiar el tiempo de descanso entre oleadas
export var cooldownOleadas = 4

var pasarRonda = true
export (float) var spawntimer = 2
export var speedincrease = 0.01
var actualtimer = 2
var score = 0
var cacademons = 0
var slimes = 0
var rondasPuntos = 1

#Oleadas_variables
var bichosmuertos = 0
var rondas = 0
export var bichosIniciales = 15
export var tiempoInicial = 12
export var incrementoBichosPorRonda = 10
export var incrementoTiempoPorRonda = 6.67
export var rondasParaIncrementoCaracol = 1
var contadorInternoRondasCaracol = 0
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
	
	
	
	
	$Viewport.add_child(enemy)
	
func _spawnEnemy2():
	var enemy2 = Enemy2.instance()
	var enemy2_spawn_location = get_node("Viewport/enemyPath2/enemySpawn2")
	enemy2_spawn_location.unit_offset = randi()%2
	var direction2 = enemy2_spawn_location.rotation + PI / 2
	enemy2.position = enemy2_spawn_location.position
	
	
	
	$Viewport.add_child(enemy2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_on_Timer_timeout(delta)
	_score()
	actualtimer = actualtimer - 1*delta
	
	if tiempo3 >= 2:
		if get_tree().get_root().get_node("EscenaMain/Viewport/Player").state == DEAD:
			playerAlive = false
	
	#Tiempo entre Oleadas		
	if tiempo4 >= cooldownOleadas && pasarRonda == true:
		_inicioRonda()
		tiempo4 = 0
		pasarRonda = false
	
	
	if playerAlive :
		
		if rondas>0 && (tiemporonda == 0 || bichosronda == 0) && pasarRonda==false:
			tiempo4 = 0
			pasarRonda = true
		
		if tiempo >= 1:
			tiemporonda -= 1
			tiempo = 0
			
			# Se llega al spawn de un nuevo enemigo
		if tiempo2 >= spawntimer && bichosronda != 0:
			
			if actualEnemy2InRound < maxEnemy2InRound:
				enemyKindSpawnDecider = randi()%2
				if enemyKindSpawnDecider == 1 || tiempo5 < 2:
					_spawnEnemy1()
				else:
					tiempo5 = 0
					_spawnEnemy2()
					actualEnemy2InRound += 1
			else:
				_spawnEnemy1()
			bichosronda -= 1
			tiempo2 = 0
		
	
	

	$Gui/TextureRect.rect_size.x = $Viewport/Player.currentHealth
	$Gui/TextureRect2.rect_size.x = $Viewport/Gea.currentHealth
	
	# sistema de disparo
	$Viewport/Player.mousePos = $Viewport/Target.mousePos
	

func _inicioRonda():
	rondas += 1
	rondasPuntos += 0.25
	
	
	bichosronda = bichosIniciales + incrementoBichosPorRonda * (rondas-1)
	tiemporonda = tiempoInicial + incrementoTiempoPorRonda * (rondas-1)
	spawntimer = tiemporonda/bichosronda
	
	actualEnemy2InRound = 0
	
	if rondasParaIncrementoCaracol == contadorInternoRondasCaracol:
		maxEnemy2InRound += 1
		contadorInternoRondasCaracol = 0
	else:
		contadorInternoRondasCaracol += 1

func _on_Timer_timeout(delta):
	tiempo += 1 * delta
	tiempo2 += 1 * delta
	tiempo3 += 1 * delta
	tiempo4 += 1 * delta
	tiempo5 += 1 * delta
func _score():
	score = ((cacademons * 10) + (slimes * 75)) * (rondasPuntos)

