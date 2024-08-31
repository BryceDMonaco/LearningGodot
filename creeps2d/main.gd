extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hit() -> void:
	pass # Replace with function body.


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the mob
	var mob = mob_scene.instantiate()
	
	# Get the MobSpawnLocation position then move it to a random point
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Get a direction perpendicular to the path's direction,
	# should be facing inward
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the new mob's position to the spawn location
	mob.position = mob_spawn_location.position
	
	# Randomly change the rotation a bit and then assign it to the mob
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose a random velocity for the mob and set it
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Actually spawn the mob
	add_child(mob)
	

func _on_score_timer_timeout() -> void:
	score += 1


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
