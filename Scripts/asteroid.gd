extends RigidBody2D

@export var scene_asteroid : PackedScene

# GENERAL OBJECT DATA
var data_block := 0
var data_resistance := 0
var data_attackInterval := 1.0
var data_damage := 0.0
var data_health := 300.0
var data_maxHealth := 300.0
var data_speed := 0.0
var data_turnSpeed := 0.0
var data_team := 0
var data_type := "debris"

# CUSTOM OBJECT DATA
var roll := 0.0
var direction := 0.0
var renderCount := 0
var randomize := true
var can_bump:= false

func _ready() -> void:
	# Presets
	if randomize:
		var tempScale = 1.0 + (0.20 * randi_range(-2, 2))
		scale = Vector2(tempScale, tempScale)
		direction = randf_range(0.0, 2.0*PI)
		data_speed = randf_range(40.0, 60.0) * scale.x
		roll = randf_range(-0.5, 0.5) * scale.x
		$Sprites.scale = scale
		$CollisionShape2D.scale = scale
		$Area2D.scale = scale
		data_health = (200 * tempScale) * pow(2.5, tempScale)

func _process(delta: float) -> void:
	var velocity = Vector2(cos(direction), sin(direction)) * data_speed
	
	move_and_collide(velocity * delta)
	rotation += roll * delta
	
	if data_health <= 0.0:
		queue_free()

func _on_duration_timeout() -> void:
	queue_free()

func bump(body: Node2D) -> void:
	if body.data_type == "debris" and body != self:
		var m1 = scale.x
		var m2 = body.scale.x

		# Positions and velocities
		var p1 = global_position
		var p2 = body.global_position
		var v1 = Vector2(cos(direction), sin(direction)) * data_speed
		var v2 = Vector2(cos(body.direction), sin(body.direction)) * body.data_speed

		# Collision normal and tangent
		var normal = (p2 - p1).normalized()
		var tangent = Vector2(-normal.y, normal.x)

		# Project velocities onto normal and tangent
		var v1n = v1.dot(normal)
		var v1t = v1.dot(tangent)
		var v2n = v2.dot(normal)
		var v2t = v2.dot(tangent)

		# New normal velocities after collision (1D elastic)
		var v1n_after = ((v1n * (m1 - m2)) + (2 * m2 * v2n)) / (m1 + m2)
		var v2n_after = ((v2n * (m2 - m1)) + (2 * m1 * v1n)) / (m1 + m2)

		# Final velocity vectors
		var new_v1 = (v1n_after * normal) + (v1t * tangent)
		var new_v2 = (v2n_after * normal) + (v2t * tangent)

		# Update direction and speed
		data_speed = new_v1.length()
		direction = new_v1.angle()

		body.data_speed = new_v2.length()
		body.direction = new_v2.angle()
		