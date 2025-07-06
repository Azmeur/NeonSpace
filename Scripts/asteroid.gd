extends RigidBody2D

# GENERAL OBJECT DATA
var data_block := 0
var data_resistance := 0
var data_attackInterval := 1.0
var data_damage := 0.0
var data_health := 300.0
var data_maxHealth := 300.0
var data_speed := 100.0
var data_turnSpeed := 0.0
var data_team := 0
var data_type := "debris"

# CUSTOM OBJECT DATA
var roll := 10.0
var renderCount := 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var velocity = Vector2(cos(rotation), sin(rotation)) * data_speed
	
	move_and_collide(velocity * delta)
	rotation += roll * delta

func _on_duration_timeout() -> void:
	queue_free()
