extends Node2D

# UNITS
@export var scene_player : PackedScene
@export var scene_asteroid : PackedScene

# PROJECTILES
@export var scene_bullet : PackedScene
var projectiles : Array

var player : Node

func _ready() -> void:
	projectiles.append(scene_bullet)
	
	# TEST
	player = scene_player.instantiate()
	player.entity_projectiles = projectiles
	inheritNodes(player)
	player.is_selected = true
	player.node_movement = $UI/Movement
	player.node_aim = $UI/Aim
	call_deferred("add_child", player)
	
	for n in range(50):
		var asteroid = scene_asteroid.instantiate()
		var angle = deg_to_rad(randf_range(0.0, 360.0))
		asteroid.position.x = cos(angle) * randf_range(200.0, 1800.0)
		asteroid.position.y = sin(angle) * randf_range(200.0, 1800.0)
		call_deferred("add_child", asteroid)

func inheritNodes(body: Node) -> void:
	body.node_main = self

func _process(delta: float) -> void:
	$BG.global_position = player.global_position
