extends Node2D

func dealDamage(source: body, target: body, damage: float) -> void:
  var calculatedDamage = Min((Min(0.0, 1.0 - target.data_resistance) * damage) - target.data_block, 0.0)
  target.data_health -= calculatedDamage