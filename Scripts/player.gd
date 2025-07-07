extends CharacterBody2D

@onready var sprites = $Sprites

var entity_projectiles : Array

var node_main : Node
var node_gameControl : Node
var node_movement : Node
var node_aim : Node

var is_set := false

# GENERAL OBJECT DATA
var data_block := 0
var data_resistance := 0
var data_attackInterval := 0.3
var data_damage := 10.0
var data_health := 100.0
var data_maxHealth := 100.0
var data_speed := 300.0
var data_turnSpeed := 120.0
var data_team := 0
var data_type := "unit"

# CUSTOM OBJECT DATA
var speed = 0.0
const minSpeed = 20.0
const acceleration = 500.0
const deceleration = 300.0

var is_selected := false

# --------------------------------------------------------------
var attack_cooldown := 0.0
func _physics_process(delta: float) -> void:
	# Movement Control
	var targVector = node_movement.posVector
	targVector.x = clamp(targVector.x * 2, -1, 1)
	targVector.y = clamp(targVector.y * 2, -1, 1)
	
	if data_health > 0.0:
		if is_selected:
			rotation += deg_to_rad(targVector.x * data_turnSpeed * delta)

	if targVector.y < 0 and is_selected:
		speed += abs(targVector.y) * acceleration * delta
	else:
		speed -= deceleration * delta
	speed = clamp(speed, minSpeed, data_speed)
	velocity = Vector2(cos(rotation), sin(rotation)) * speed
	
	move_and_collide(velocity * delta)
	
	# Shoot Projectiles
	if attack_cooldown <= 0 and node_aim.pressing and is_selected:
		attack_cooldown = data_attackInterval
		var bullet = entity_projectiles[0].instantiate()
		bullet.global_position = global_position
		bullet.data_team = data_team
		bullet.rotation = rotation + node_aim.posVector.angle() + deg_to_rad(90)
		node_main.call_deferred("add_child", bullet)
	else:
		attack_cooldown = max(attack_cooldown - delta, 0.0)

	# Death
	if data_health <= 0.0:
		queue_free()

func renderIn(body: Node2D) -> void:
	if body.data_type == "projectile" or body.data_type == "debris":
		body.renderCount += 1

func renderOut(body: Node2D) -> void:
	if body.data_type == "projectile" or body.data_type == "debris":
		if body.renderCount <= 1:
			body.queue_free()
		else:
			body.renderCount -= 1
