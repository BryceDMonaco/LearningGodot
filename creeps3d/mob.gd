extends CharacterBody3D

signal squashed

# Min and max move speeds m/s
@export var min_speed : int = 10
@export var max_speed : int = 18

func initialize(start_position : Vector3, player_position : Vector3) -> void:
	# Ignore the player's vertical position, otherwise mob will point up or down
	player_position.y = start_position.y
	
	# Place mob at start_position and rotate it to look at player
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# Randomly adjust the mob rotation
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	var random_speed : int = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func squash() -> void:
	squashed.emit()
	queue_free()
