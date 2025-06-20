extends CharacterBody2D

var object_projectiles : Array

var node_main : Node

var is_set := false

# GENERAL OBJECT DATA
var data_armor := 0
var data_resistance := 0
var data_attackInterval := 1.0
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

func _physics_process(delta: float) -> void:
	# Movement Control
	if data_health > 0.0:
		if Input.is_action_pressed("a"):
			rotation -= deg_to_rad(turnSpeed * delta)
		elif Input.is_action_pressed("d"):
			rotation += deg_to_rad(turnSpeed * delta)
		
		if Input.is_action_pressed("w"):
			speed += acceleration * delta
		else:
			speed -= deceleration * delta
		speed = clamp(speed, minSpeed, data_speed)
		velocity = Vector2(cos(rotation), sin(rotation)) * speed
	
		move_and_collide(velocity * delta)
