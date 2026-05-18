class_name Enemy
extends CharacterBody2D

@onready var sprites = $Sprites

var context : Context

var entity_squadMembers : Array

var is_set := false

# GENERAL OBJECT DATA
var data_block := 0
var data_resistance := 0
var data_attackInterval := 0.1
var data_damage := 10.0
var data_health := 100.0
var data_maxHealth := 100.0
var data_speed := 400.0
var data_turnSpeed := 110.0
var data_team := -2
var data_type := "unit"

# CUSTOM OBJECT DATA
var speed = 0.0
const minSpeed = 50.0
const acceleration = 500.0
const deceleration = 300.0
var oldDirection = deg_to_rad(-90)

# STATES
var state_isDead := false
var state_isAlert := false

# --------------------------------------------------------------
var node_squadControl : Node
var attack_cooldown := 0.0
func _physics_process(delta: float) -> void:
	if false and isPlayerVisible():
		state_isAlert = true
		node_squadControl.alert()
		$PursuitCountdown.start(10.0)
		pursuitAlert()
	
	var toPlayer = (context.player.global_position - global_position).normalized()
	if not state_isDead:
		var targAngle = rotation
		var is_avoiding = false
		if $RayCastLeft.is_colliding():
			targAngle += deg_to_rad(data_turnSpeed)
			is_avoiding = true
		elif $RayCastLeft2.is_colliding():
			var targDist = global_position.distance_to($RayCastLeft2.get_collision_point())
			var t = clamp((targDist - 50.0) / 150.0, 0.0, 1.0)
			var piecewiseClamp = 1.0 - t
			targAngle += deg_to_rad(data_turnSpeed) * piecewiseClamp
			is_avoiding = true
		if $RayCastRight.is_colliding():
			targAngle -= deg_to_rad(data_turnSpeed)
			is_avoiding = true
		elif $RayCastRight2.is_colliding():
			var targDist = global_position.distance_to($RayCastRight2.get_collision_point())
			var t = clamp((targDist - 50.0) / 150.0, 0.0, 1.0)
			var piecewiseClamp = 1.0 - t
			targAngle -= deg_to_rad(data_turnSpeed) * piecewiseClamp
			is_avoiding = true
		if state_isAlert and not is_avoiding:
			targAngle = toPlayer.angle()
		rotation = rotate_toward(rotation, targAngle, deg_to_rad(data_turnSpeed)*delta)

	if ($RayCastLeft.is_colliding() or $RayCastLeft2.is_colliding() and $RayCastRight.is_colliding() or $RayCastRight2.is_colliding()) or not state_isAlert:
		speed -= deceleration * delta
	else:
		speed += data_speed * acceleration * delta
	speed = clamp(speed, minSpeed, data_speed)
	velocity = Vector2(cos(rotation), sin(rotation)) * speed
	
	if data_health > 0.0:
		move_and_collide(velocity * delta)
	
	# Shoot Projectiles
	var ai_aimAngle = toPlayer.angle() + deg_to_rad(randf_range(-10.0, 10.0))
	var ai_finalAim = Vector2(cos(ai_aimAngle), sin(ai_aimAngle))
	if state_isAlert and not $RayCastDetection.is_colliding() and attack_cooldown <= 0 and ai_finalAim != Vector2.ZERO and not state_isDead:
		attack_cooldown = data_attackInterval
		var bullet = context.projectiles[0].instantiate()
		bullet.global_position = global_position
		bullet.data_team = data_team
		bullet.rotation = ai_aimAngle
		context.main.call_deferred("add_child", bullet)
	else:
		attack_cooldown = max(attack_cooldown - delta, 0.0)
	
	oldDirection = oldDirection if not state_isAlert else toPlayer.angle()
	$Sprites/SpriteGun.global_rotation = oldDirection + deg_to_rad(90)

func physicalCollision(body: Node2D) -> void:
	if body.data_type == "projectile" or body.data_type == "debris":
		if body.data_type == "debris":
			pass

func death():
	data_health = -1
	$Sprites.visible = false
	state_isDead = true
	# Death Animation
	queue_free()

func pursuitAlert() -> void:
	for body in entity_squadMembers:
		if not body.state_isAlert and body != self:
			body.state_isAlert = true

func pursuitLost() -> void:
	state_isAlert = false

func isPlayerVisible() -> bool:
	if global_position.distance_to(context.player.global_position) <= 1000:
		$RayCastDetection.target_position = to_local(context.player.global_position)
		return not $RayCastDetection.is_colliding()
	return false
