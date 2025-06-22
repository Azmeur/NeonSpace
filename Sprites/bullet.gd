extends RigidBody2D

var node_main : Node
var node_gameControl : Node

# GENERAL OBJECT DATA
var data_block := 0
var data_resistance := 0
var data_attackInterval := 1.0
var data_damage := 10.0
var data_health := 100.0
var data_maxHealth := 100.0
var data_speed := 1200.0
var data_turnSpeed := 0.0
var data_team := 0
var data_type := "projectile"

# CUSTOM OBJECT DATA
var source : Node
var renderCount := 0

var isRendered := false

func _process(delta: float) -> void:
	var velocity = Vector2(cos(rotation), sin(rotation)) * data_speed
	move_and_collide(velocity * delta)

func entityHit(body: Node2D) -> void:
	if body.data_type == "debree":
		node_gameControl.dealDamage(self, body, data_damage)
		queue_free()
	if body.data_type == "unit" and body.data_team != data_team:
		node_gameControl.dealDamage(self, body, data_damage)
		queue_free()
