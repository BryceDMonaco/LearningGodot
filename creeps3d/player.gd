extends CharacterBody3D

signal hit

# Player speed in m/s
@export var speed : int = 14

# Downward acceleration in m/s^2
@export var fall_acceleration : int = 75

# Vertical impulse for jumping in m/s
@export var jump_impulse : int = 20

# Veritcal impulse for bouncing off of mobs in m/s
@export var bounce_impulse : int = 16

var target_velocity : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
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
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Check all collisions in this frame
	for index in range(get_slide_collision_count()):
		var collision : KinematicCollision3D = get_slide_collision(index)
		
		# Check if the collision is the ground
		if collision.get_collider() == null:
			continue
		elif collision.get_collider().is_in_group("mob"):
			var mob : Node3D = collision.get_collider()
			
			# Check if we are hitting from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
	
	move_and_slide()


func die() -> void:
	hit.emit()
	queue_free()


func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
