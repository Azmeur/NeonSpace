extends CharacterBody2D

var entity_projectiles : Array

var node_main : Node

var is_set := false

# GENERAL OBJECT DATA
var data_armor := 0
var data_resistance := 0
var data_attackInterval := 1.0
var data_damage := 10.0
var data_health := 100.0
var data_maxHealth := 100.0
var data_speed := 300.0
var data_turnSpeed := 180.0
var data_team := 0
var data_type := "unit"

# CUSTOM OBJECT DATA
var speed = 0.0
const minSpeed = 50.0
const turnSpeed = 180.0
const acceleration = 500.0
const deceleration = 300.0

var is_selected := false

# --------------------------------------------------------------
var attack_cooldown := 0.0
func _physics_process(delta: float) -> void:
	# Movement Control
	if data_health > 0.0:
		if Input.is_action_pressed("a") and is_selected:
			rotation -= deg_to_rad(turnSpeed * delta)
		elif Input.is_action_pressed("d") and is_selected:
			rotation += deg_to_rad(turnSpeed * delta)
		
		if Input.is_action_pressed("w") and is_selected:
			speed += acceleration * delta
		else:
			speed -= deceleration * delta
		speed = clamp(speed, minSpeed, data_speed)
		velocity = Vector2(cos(rotation), sin(rotation)) * speed
		
		move_and_collide(velocity * delta)
	
	# Shoot Projectiles
	if attack_cooldown <= 0 and Input.is_action_pressed("click") and is_selected:
		attack_cooldown = data_attackInterval
		var bullet = entity_projectiles[0].instantiate()
		bullet.global_position = global_position
		bullet.rotation = rotation
		node_main.call_deferred("add_child", bullet)
	else:
		attack_cooldown = max(attack_cooldown - delta, 0.0)
	
	# Death
	if data_health <= 0.0:
		queue_free()

func renderIn(body: Node2D) -> void:
	if body.data_type == "projectile":
		body.renderCount += 1
		body.isRendered = true

func renderOut(body: Node2D) -> void:
	if body.data_type == "projectile":
		body.renderCount -= 1