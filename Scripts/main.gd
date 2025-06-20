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
	player.object_projectiles = projectiles
	player.node_main = self
	call_deferred("add_child", player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
