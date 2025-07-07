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
var renderCount := 0
var randomize := true
var can_bump:= false

func _ready() -> void:
	# Presets
	if randomize:
		var tempScale = 0.5 + (0.25 * randi_range(0, 5))
		scale = Vector2(tempScale, tempScale)
		rotation = randf_range(0.0, 2.0*PI)
		data_speed = randf_range(40.0, 60.0) * scale.x
		roll = randf_range(-0.5, 0.5) * scale.x
		$Sprites.scale = scale
		$CollisionShape2D.scale = scale
		$Area2D.scale = scale
		data_health = (200 * tempScale) * pow(2.5, tempScale)

func _process(delta: float) -> void:
	var velocity = Vector2(cos(rotation), sin(rotation)) * data_speed
	
	move_and_collide(velocity * delta)
	$Sprites.rotation += roll * delta
	
	if data_health <= 0.0:
		queue_free()

func _on_duration_timeout() -> void:
	queue_free()

func bump(body: Node2D) -> void:
	if body.data_type == "debris":
		var totalScale = scale.x + body.scale.x
		var totalSpeed = data_speed + body.data_speed
		var angle = global_position.angle_to_point(body.global_position)
		
		data_speed = totalSpeed * (scale.x / totalScale)
		rotation = angle + PI
		body.data_speed = totalSpeed * (body.scale.x / totalScale)
		body.rotation = angle
