extends KinematicBody2D

export (PackedScene) var SFXEnemyDeath

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 100
export var deadSpeed = 300
var velocity = Vector2.ZERO
enum {IDLE, ATTACK, HIT, DIE}
var state = IDLE
var dead = false
export var playerDamage = 20
export var geaDamage = 20
export var heal = 10
export var hits = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if get_tree().get_root().get_node("EscenaMain/Viewport/enemyPath2/enemySpawn2").unit_offset == 1:
		$EnemyAnimations.flip_h = false
		speed = speed*-1
	if get_tree().get_root().get_node("EscenaMain/Viewport/enemyPath2/enemySpawn2").unit_offset != 1:
		$EnemyAnimations.flip_h = true
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if hits <= 0:
		state = DIE
	
	
	
	match (state):
		IDLE: process_idle(delta)
		ATTACK: process_attack(delta)
		HIT: process_hit(delta)
		DIE: process_die(delta)
	return

func process_idle(delta):
	$EnemyAnimations.animation = "Walk"

	velocity.x = speed
	velocity = move_and_slide(velocity, Vector2.RIGHT)

func process_attack(delta):
	#if $AnimatedSprite.frame == 5:
		
	return
	
func process_hit(delta):
	
	$EnemyAnimations.animation = "Hit"
	if $EnemyAnimations.frame == 4:
		state = IDLE

	return
	
func process_die(delta):
	if SFXEnemyDeath:
		get_tree().get_root().get_node("EscenaMain/Viewport").add_child(SFXEnemyDeath.instance())

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

	if body.getType() == "Gea" && state == DIE:
		heal(body)
		queue_free()
	if body.getType() == "Projectile"&& state != DIE:
		hits -=1
		body.queue_free()
		state = HIT
		print(hits)
	print(body.getType())
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
	return  "Enemy02"
