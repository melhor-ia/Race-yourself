extends Path2D

enum State{IDLE,TRACKING,PLAYING}

@export var player:DeLorian
@export var ghost_scene:PackedScene

var state:State = State.IDLE
var point:int = 0

func _on_area_2d_lap_over() -> void:
	if state == State.IDLE:
		start_tracking()
	else:
		spawn_ghost()
		state = State.PLAYING

func _on_timer_timeout() -> void:
	curve.add_point(player.global_position)

func _physics_process(delta: float) -> void:
	if not state == State.PLAYING: return
	for child in get_children():
		if child is not Ghost: continue
		var ghost = child as Ghost
		var distance = (ghost.global_position - curve.get_point_position(ghost.point)).length()
		var step_lenght = (curve.get_point_position(ghost.point) - curve.get_point_position(ghost.point+1)).length()
		if distance > 5:
			ghost.progress += step_lenght*delta*10
		else:
			ghost.point += 1

func start_tracking() -> void:
	state = State.TRACKING
	$Spawnpoint.global_position = player.global_position
	for particle in $Spawnpoint.get_children():
		if particle is GPUParticles2D:
			particle.emitting = true
	$TrackTimer.start()

func spawn_ghost():
	var ghost = ghost_scene.instantiate()
	ghost.global_position = curve.get_point_position(0)
	add_child(ghost)
