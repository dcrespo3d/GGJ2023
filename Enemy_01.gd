extends KinematicBody2D

export (PackedScene) var SFXEnemyDeath

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 100
var velocity = Vector2.ZERO
enum {IDLE, ATTACK, HIT, DIE}
var state = IDLE
export var damage = 20
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
	
func process_die(delta):
	if SFXEnemyDeath:
		get_tree().get_root().get_node("EscenaMain/Viewport").add_child(SFXEnemyDeath.instance())
	queue_free()
	return



func _on_Area2D_body_entered(body):
	if body.getType() == "Player":
		attack(body)
		queue_free()

	if body.getType() == "Gea":
		attack(body)
		queue_free()
	if body.getType() == "Projectile":
		hits -=1
		body.queue_free()
		state = HIT
		print(hits)
	print(body.getType())
	pass # Replace with function body.
func attack(body):
	body._takeHit(damage)
	state = ATTACK
func getType():
	return  "Enemy01"
