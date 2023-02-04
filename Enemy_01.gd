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
export var damage = 20
export var heal = 10
export var hits = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


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
		attack(body)
		queue_free()

	if body.getType() == "Gea" && state == IDLE:
		attack(body)
		queue_free()
	if body.getType() == "Gea" && state == DIE:
		heal(body)
		queue_free()
	if body.getType() == "Projectile"&& state != DIE:
		if SFXEnemyHit != null:
			var sfx_enemy_hit = SFXEnemyHit.instance()
			get_tree().get_root().get_node("EscenaMain/Viewport").add_child(sfx_enemy_hit)

		hits -=1
		body.queue_free()
		state = HIT
		print(hits)
	print(body.getType())
	pass # Replace with function body.
func attack(body):
	body._takeHit(damage)
	state = ATTACK
func heal(body):
	body._takeHeal(heal)
func getType():
	return  "Enemy01"
