# Extend
extends CharacterBody2D


# Variables
var Speed = 2000.0
var SpeedMultiplier = 1.0


# Delegates
signal recycle


# Funcs and Defs
func _physics_process(delta):
	# Update Movement
	var direction = get_movement_direction() 
	velocity = direction * Speed * SpeedMultiplier * delta

	move_and_slide()

func get_movement_direction():
	return global_position - get_tree().get_node("GameRoot").get_player_position()
