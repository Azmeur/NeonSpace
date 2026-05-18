extends Node2D

# UNITS
@export var scene_player : PackedScene
@export var scene_asteroid : PackedScene
@export var scene_enemy : PackedScene

# PROJECTILES
@export var scene_bullet : PackedScene
var projectiles : Array

var player : Node

# SETTINGS
var renderDistance = 3000

var context = Context.new()
func _ready() -> void:
	context.main = self
	context.game_control = $GameControl
	context.projectiles.append(scene_bullet)
	
	$GameControl.context = context
	#------------------------------------------------
	# TEST
	player = scene_player.instantiate()
	player.entity_projectiles = projectiles
	inheritNodes(player)
	player.is_selected = true
	player.debris_nextWeight = lerp(0.7, 4.5, pow(randf(), 2.8))
	player.node_movement = $UI/Movement
	player.node_aim = $UI/Aim
	call_deferred("add_child", player)
	
	$GameControl.node_player = player
	
	var spawnWeight = 100.0
	var angle = 0.0
	while(spawnWeight >= 2.0):
		var asteroid = scene_asteroid.instantiate()
		angle = deg_to_rad(randf_range(0.0, 360.0))
		asteroid.position.x = cos(angle) * randf_range(500.0, 1800.0)
		asteroid.position.y = sin(angle) * randf_range(500.0, 1800.0)
		asteroid.node_main = self
		asteroid.scene_asteroid = scene_asteroid
		spawnWeight -= asteroid.setup()
		
		call_deferred("add_child", asteroid)

func inheritNodes(body: Node) -> void:
	body.node_main = self
	body.node_gameControl = $GameControl

func _process(delta: float) -> void:
	$BG.global_position = player.global_position
