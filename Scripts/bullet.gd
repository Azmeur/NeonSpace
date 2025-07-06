extends RigidBody2D

# GENERAL OBJECT DATA
var data_block := 0
var data_resistance := 0
var data_attackInterval := 1.0
var data_damage := 10.0
var data_health := 100.0
var data_maxHealth := 100.0
var data_speed := 2000.0
var data_turnSpeed := 0.0
var data_team := -1
var data_type := "projectile"

# CUSTOM OBJECT DATA
var duration := 1.0
var renderCount := 0

func _ready() -> void:
	$Duration.start(duration)
	#for area in get_tree().get_nodes_in_group("renderAreas"):
	#	renderCount += 1 if area.get_overlapping_bodies().has(self) else 0

func _process(delta: float) -> void:
	var velocity = Vector2(cos(rotation), sin(rotation)) * data_speed
	
	move_and_collide(velocity * delta)
	print(renderCount)

func _on_duration_timeout() -> void:
	queue_free()

func hit(body: Node2D) -> void:
	if body.data_type == "unit" or body.data_type == "debris":
		if body.data_team != data_team:
			body.data_health -= data_damage
			queue_free()
