extends CharacterBody2D

@export var tracker:Marker2D
@export var tolerance_range:float = 300

func _physics_process(delta: float) -> void:
	_slide_to_focus(delta)

func _slide_to_focus(delta:float) -> void:
	var goal:Vector2 = tracker.global_position
	var direction:Vector2 = (goal - global_position).normalized()
	var distance:float = (goal - global_position).length()
	
	global_position = global_position + (distance*direction)
