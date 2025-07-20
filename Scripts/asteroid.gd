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
var renderCount := 0
var initialSpin := 0.0

func _ready() -> void:
	mass = 1.0 + (0.20 * randi_range(-2, 2))
	scale = Vector2(mass, mass)
	var speed = randf_range(40.0, 60.0)
	var angle = randf_range(0.0, 2*PI)
	apply_impulse(Vector2(speed*cos(angle), speed*sin(angle)))
	initialSpin = mass * randf_range(0, PI)
	rotation = initialSpin
	$Sprites.scale = scale
	$CollisionShape2D.scale = scale
	data_health = (200 * mass) * pow(2.5, mass)
	contact_monitor = true
	max_contacts_reported = 1

func _process(delta: float) -> void:
	if data_health <= 0.0:
		queue_free()

func _on_duration_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body != self and initialSpin != 0.0:
		initialSpin = 0.0
