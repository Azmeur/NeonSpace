extends Node2D

# UNITS
@export var scene_player : PackedScene

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
	call_deferred("add_child", player)
	
	var player2 = scene_player.instantiate()
	player2.entity_projectiles = projectiles
	player2.position = Vector2(800, 0)
	player2.rotation = deg_to_rad(180)
	player2.data_team = -1
	inheritNodes(player2)
	call_deferred("add_child", player2)

func inheritNodes(body: Node) -> void:
	body.node_main = self
	body.node_gameControl = $Main/GameControl