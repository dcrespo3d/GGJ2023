extends KinematicBody2D


export (PackedScene) var SFXEnemyDeath
export (PackedScene) var SFXEnemyHit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 100
export var deadSpeed = 100
var velocity = Vector2.ZERO
enum {IDLE, ATTACK, HIT, DIE}
var state = IDLE
var dead = false
export var playerDamage = 20
export var geaDamage = 20
export var heal = 10
export var hits = 3
var hemuerto = false



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("EscenaMain").bichosmuertos += 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if hits <= 0:
		state = DIE
		if state == DIE && !hemuerto:
			get_tree().get_root().get_node("EscenaMain").cacademons += 1
			hemuerto = true
	
	if $SpriteParticlesEnemy.frame == 15 && $SpriteParticlesEnemy.visible==true:
		_destroy()
	
	
	match (state):
		IDLE: process_idle(delta)
		ATTACK: process_attack(delta)
		HIT: process_hit(delta)
		DIE: process_die(delta)
	return

func process_idle(delta):
	$EnemyAnimations.animation = "Idle"
	velocity.y = speed
	velocity = move_and_slide(velocity, Vector2.UP)

func process_attack(delta):
	#if $AnimatedSprite.frame == 5:
		
	return
	
func process_hit(delta):
	$EnemyAnimations.animation = "Hit"
	if $EnemyAnimations.frame == 3:
		state = IDLE
	return

var sfx_enemy_death = null

func process_die(delta):
	if SFXEnemyDeath != null:
		if sfx_enemy_death == null:
			sfx_enemy_death = SFXEnemyDeath.instance()
			get_tree().get_root().get_node("EscenaMain/Viewport").add_child(sfx_enemy_death)

	$EnemyAnimations.animation = "Die"
	
	velocity.y = deadSpeed
	velocity = move_and_slide(velocity, Vector2.UP)

	return



func _on_Area2D_body_entered(body):
	if body.getType() == "Player" && state == IDLE:
		attackPlayer(body)
		queue_free()

	if body.getType() == "Gea" && state == IDLE:
		attackGea(body)
		_spawnParticle(false)
		


	if body.getType() == "Gea" && state == DIE:
		deadSpeed = 0
		position.y = position.y -10
		heal(body)
		_spawnParticle(true)
		
	if body.getType() == "Projectile"&& state != DIE:
		if SFXEnemyHit != null:
			var sfx_enemy_hit = SFXEnemyHit.instance()
			get_tree().get_root().get_node("EscenaMain/Viewport").add_child(sfx_enemy_hit)

		hits -=1
		body.queue_free()
		state = HIT
	pass # Replace with function body.
func attackPlayer(body):
	body._takeHit(playerDamage)
	state = ATTACK
func attackGea(body):
	body._takeHit(geaDamage)
	state = ATTACK
func heal(body):
	body._takeHeal(heal)
func getType():
	return  "Enemy01"
	
func _spawnParticle(ParticleGood):
	if ParticleGood:
		$SpriteParticlesEnemy.animation = "FloorGainLife"
	if !ParticleGood:
		$SpriteParticlesEnemy.animation = "FloorLooseLife"
	$SpriteParticlesEnemy.visible=true
	$EnemyAnimations.visible=false
	
func _destroy():
	queue_free()
