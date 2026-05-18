extends Node2D

@export var scene_enemy : PackedScene

var data_squadMembers : Array
var data_formation : String
var data_wanderLoc : Vector2
var data_validFormations := ["zigzag"]

var state_isAlert := false

# --------------------------------------------------
var node_projectiles : Array
# MAIN NODES
var node_main : Node2D
var node_gameControl : Node2D
var node_player : CharacterBody2D

enum Extras { SHOOTERS }
func passNodes(child: Node, extras:=0) -> void:
	child.node_main = node_main
	child.node_gameControl = node_gameControl
	child.node_player = node_player
	if extras & Extras.SHOOTERS:
		child.node_projectiles = node_projectiles
# --------------------------------------------------
func generate(amount:int, forms:="") -> void:
	assert(forms in data_validFormations or forms == "", "\""+forms+"\" is not a valid formation. See enemy_shipsquad.gd")
	var enemyFacing = randf_range(0, 2*PI)
	rotation = enemyFacing
	for i in range(amount):
		var enemy = scene_enemy.instantiate()
		if i == 0:
			var tempX = -75 * i
			var tempY = 50 if i%2==0 else -50
			enemy.global_position = global_position + Vector2(tempX, tempY)
		else:
			enemy.global_position = global_position
		enemy.rotation = enemyFacing
		# PASSING NODES
		passNodes(enemy, Extras.SHOOTERS)
		enemy.node_squadControl = self
		call_deferred("add_child", enemy)

# Soon would be available for individual players
func alert() -> void:
	for member in data_squadMembers:
		if member.get("state_isAlert")!=null and member.state_alert == false:
			member.state_isAlert = true

func targetLost() -> void:
	# Return formation
	if data_formation == "zigzag":
		for i in range(data_squadMembers.size()):
			if i == 0:
				continue
			var tempX = -75 * i
			var tempY = 50 if i%2==0 else -50
			var targLoc = data_squadMembers[0].global_position + Vector2(tempX, tempY)
			data_squadMembers[i].move(targLoc)
