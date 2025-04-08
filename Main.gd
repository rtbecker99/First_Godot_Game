extends Node

@export var mob_scene: PackedScene
var score


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
#	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	$Music.play()
	score = 0
	$HUD.update_score(score)
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# choose a random location on the Path2D
	var mob_spawn_location: PathFollow2D = get_node("MobPath/MobSpawnLocation")
	# offset is the distance along the path, looks like it loops
	mob_spawn_location.progress = randi()
	
	# Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	# Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the main scene
	# New instances need to be added using add_child()
	add_child(mob)
