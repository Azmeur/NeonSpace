extends Node2D

# UNITS
@export var scene_player : PackedScene
@export var scene_asteroid : PackedScene

# PROJECTILES
@export var scene_bullet : PackedScene
var projectiles : Array

func _ready() -> void:
	projectiles.append(scene_bullet)
	
	# TEST
	var player = scene_player.instantiate()
	player.entity_projectiles = projectiles
	inheritNodes(player)
	player.is_selected = true
	player.node_movement = $CanvasLayer/Movement
	player.node_aim = $CanvasLayer/Aim
	call_deferred("add_child", player)
	
	for n in range(50):
		var asteroid = scene_asteroid.instantiate()
		var angle = deg_to_rad(randf_range(0.0, 360.0))
		asteroid.position.x = cos(angle) * randf_range(200.0, 1800.0)
		asteroid.position.y = sin(angle) * randf_range(200.0, 1800.0)
		call_deferred("add_child", asteroid)

func inheritNodes(body: Node) -> void:
	body.node_main = self
