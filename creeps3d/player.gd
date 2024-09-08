extends CharacterBody3D

# Player speed in m/s
@export var speed : int = 14

# Downward acceleration in m/s^2
@export var fall_acceleration : int = 75

var target_velocity : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	print("_physics_process")
	var direction : Vector3 = Vector3.ZERO
	
	# Check for inputs and apply to the direction
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x += -1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed;
	target_velocity.z = direction.z * speed;
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	velocity = target_velocity
	move_and_slide()
