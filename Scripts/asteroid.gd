class_name Asteroid
extends RigidBody2D

@export var scene_asteroid : PackedScene

var context: Context

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

# STATES
var state_isDead := false

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1

func _process(delta: float) -> void:
	if data_health <= 0.0:
		death()

func setup(targMass:=0.0) -> float:
	# Origin in the place where the asteroid drifts away
	var tempMass = lerp(0.7, 4.5, pow(randf(), 2.8)) if targMass <= 0.0 else targMass
	var speed = randf_range(80.0, 120.0) / tempMass
	spawn(tempMass, speed)
	return mass

func spawn(newMass:float, speed:float) -> void:
	mass = newMass
	linear_damp = mass * 0.06
	angular_damp = mass * 0.1
	scale = Vector2(mass, mass)
	var angle = randf_range(-PI, PI)
	apply_impulse(Vector2(cos(angle)*speed, sin(angle)*speed))
	angle = randf_range(-PI, PI) / (mass * 2)
	angular_velocity = angle
	$Sprites.scale = scale
	$CollisionShape2D.scale = scale
	data_health = (200 * mass) * pow(2.5, mass)

func _on_duration_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body != self and initialSpin != 0.0:
		initialSpin = 0.0

func death():
	if not state_isDead:
		state_isDead = true
		$CollisionShape2D.visible = false
		$Sprites.visible = false
		var split = randi_range(2,4)
		var splitSize = pow(mass/2, 2) * PI / split
		while(splitSize <= 0.1 and split > 2):
			split -= 1
			splitSize = pow(mass/2, 2) * PI / split
		if splitSize > 0.1:
			for n in range(split):
				var asteroid: Asteroid = scene_asteroid.instantiate()
				var angle = deg_to_rad(randf_range(0.0, 360.0))
				asteroid.global_position.x = global_position.x + cos(angle) * randf_range(0.0, mass*128.0)
				asteroid.global_position.y = global_position.y + sin(angle) * randf_range(0.0, mass*128.0)
				asteroid.spawn(sqrt(splitSize/PI) * 2, linear_velocity.length()*0.8*split)
				asteroid.context = context
				asteroid.scene_asteroid = scene_asteroid
				
				context.main.call_deferred("add_child", asteroid)
		queue_free()
