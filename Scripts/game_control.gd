class_name GameControl
extends Node2D

@export var scene_asteroid : PackedScene
@export var scene_enemy : PackedScene

var context : Context

var entityCount = 0

func spawnAsteroid(targLoc:Vector2, targMass:float) -> void:
	var asteroid: Asteroid = scene_asteroid.instantiate()
	asteroid.position = targLoc
	asteroid.scene_asteroid = scene_asteroid
	asteroid.setup(targMass)
	asteroid.context = context
	
	call_deferred("add_child", asteroid)

func gameTick() -> void:
	if context.player != null:
		if entityCount < 15:
			var targAngle = randf_range(0, 2*PI)
			var targDistance = randf_range(context.main.renderDistance*0.4, context.main.renderDistance*0.5)
			var targSpawn = Vector2(cos(targAngle)*targDistance, sin(targAngle)*targDistance) + context.player.global_position
			
			if is_spawnPointSafe(targSpawn):
				var enemySquad = []
				var enemySquadSize = randi_range(3,5)
				var enemyFacing = randf_range(0, 2*PI)
				for i in range(enemySquadSize):
					var enemy: Enemy = scene_enemy.instantiate()
					var angle = 2*PI / enemySquadSize
					enemy.position = Vector2(cos(angle*i) * 150, sin(angle*i) * 100) + targSpawn
					enemy.context = context
					enemy.rotation = enemyFacing
					
					enemySquad.append(enemy)
					context.main.call_deferred("add_child", enemy)
				for enemy in enemySquad:
					enemy.entity_squadMembers = enemySquad
				enemySquad.clear()
				entityCount += enemySquadSize

func is_spawnPointSafe(targLoc:Vector2) -> bool:
	for rock in get_tree().get_nodes_in_group("asteroids"):
		if targLoc.distance_to(rock.global_position) < 500:
			return false
	return true
