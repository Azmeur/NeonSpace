extends RigidBody2D

var node_main : Node
var node_gameControl : Node

@export var scene_lesserAsteroid = packedScene

# GENERAL OBJECT DATA
var data_block := 0
var data_resistance := 0.2
var data_attackInterval := 1.0
var data_damage := 0.0
var data_health := 200.0
var data_maxHealth := 100.0
var data_speed := 100.0
var data_turnSpeed := 0.0
var data_team := 0
var data_type := "debree"

