extends Control

@onready var knob = $Knob
@onready var ring = $Ring

@export var maxLength = 100
@export var deadZone = 5
@export var max_distance = 100

var posVector : Vector2
var pressing = false
var touch_index = -1
var start_pos : Vector2
var default_pos : Vector2
var touch_pos : Vector2

var is_fixed := false

func _ready() -> void:
	maxLength *= scale.x
	start_pos = size/2
	default_pos = position

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if event.is_pressed() and !pressing and get_global_rect().has_point(event.position):
			pressing = true
			touch_index = event.index
			start_pos = global_position if is_fixed else event.position
			touch_pos = event.position
			ring.global_position = start_pos
		elif pressing and event.index == touch_index:
			if event is InputEventScreenDrag:
				touch_pos = event.position
			elif not event.is_pressed():
				pressing = false
				touch_index = -1

func _process(delta: float) -> void:
	if pressing:
		if touch_pos.distance_to(start_pos) <= maxLength:
			knob.global_position = touch_pos
		else:
			var angle = start_pos.angle_to_point(touch_pos)
			knob.global_position.x = start_pos.x + cos(angle)*maxLength
			knob.global_position.y = start_pos.y + sin(angle)*maxLength
		posVector = (knob.global_position - start_pos).normalized()
	
	else:
		knob.global_position = lerp(knob.global_position, default_pos+(size/2), delta*30)
		ring.global_position = default_pos+(size/2)
		posVector = Vector2.ZERO

func calculateVector() -> void:
	var direction = (knob.global_position - position)
	var distance = direction.length()
	var normalized_distance = clamp(distance / (maxLength * 0.5), 0, 1)
	posVector = direction.normalized() * normalized_distance
