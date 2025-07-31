class_name DeLorian
extends CharacterBody2D

enum State{IDLE,ACTIVE}

@export_category("assets")
@export var drift_particles:Array[GPUParticles2D]

@export_category("car settings")
@export var state:State = State.IDLE
@export var steering_max_angle := 15
@export var engine_power := 150
@export var friction := -250 
@export var drag := -0.06
@export var braking := -450
@export var max_speed_reverse := 250  
@export var speed_to_slip := 400  
@export var traction_fast := 5
@export var traction_slow := 10  

var wheels_distance := 36*2
var acceleration := Vector2.ZERO
var steer_direction:float = 0


func _physics_process(delta: float) -> void:
	if state == State.ACTIVE:
		acceleration = Vector2.ZERO
		get_input()
		calculate_steering(delta)

	velocity += acceleration * delta
	apply_friction(delta)
	move_and_slide()


func get_input() -> void:
	var turn:float = Input.get_axis("move_left", "move_right")
	steer_direction = turn * deg_to_rad(steering_max_angle)

	if Input.is_action_pressed("move_up"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("move_down"):
		acceleration = transform.x * braking


func apply_friction(delta) -> void:
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force


func calculate_steering(delta) -> void:
	var rear_wheel = position - transform.x * wheels_distance / 2.0
	var front_wheel = position + transform.x * wheels_distance / 2.0
	# Advance the wheels' positions based on the current velocity, applying rotation to the front wheel
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# Calculate the new heading based on the wheels' positions
	var new_heading = rear_wheel.direction_to(front_wheel)

	var traction = traction_fast if velocity.length() > speed_to_slip else traction_slow


	print(steer_direction==0.0)
	if steer_direction == 0 or traction == traction_slow:
		for particle in drift_particles:
			particle.emitting = false
	else:
		for particle in drift_particles:
			particle.emitting = true
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
	
