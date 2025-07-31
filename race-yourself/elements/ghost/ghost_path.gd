extends Path2D

enum State{IDLE,COUNTING,PLAYING}

@export var player:DeLorian
@export var ghost_scene:PackedScene

var state:State = State.IDLE
var point:int = 0

func _on_area_2d_lap_over() -> void:
	print("LAP")
	if state == State.IDLE:
		state = State.COUNTING
		$Marker2D.global_position = player.global_position
		for particle in $Marker2D.get_children():
			if particle is GPUParticles2D:
				particle.emitting = true
		$Timer.start()
	else:
		state = State.PLAYING
		print("spawn")
		spawn_ghost()

func _on_timer_timeout() -> void:
	curve.add_point(player.global_position)

func _physics_process(delta: float) -> void:
	if not state == State.PLAYING: return
	for ghost in get_children():
		if ghost is Ghost:
			var distance = ghost.global_position.distance_to(curve.get_point_position(ghost.point))
			var distance_points = curve.get_point_position(ghost.point-1).distance_to(curve.get_point_position(ghost.point))
			print(distance)
			if distance > 1:
				ghost.progress += distance_points*delta*10
			else:
				ghost.point += 1

func spawn_ghost():
	var ghost = ghost_scene.instantiate()
	ghost.global_position = curve.get_point_position(0)
	add_child(ghost)
