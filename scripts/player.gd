# Extend
extends CharacterBody2D


# Variables
@export var Speed = 300.0

var SpeedMultiplier = 1
var CurrentXP = 0.0

var FacingDirection


# Funcs and Defs
func _physics_process(delta):
	handle_movement(delta)

func get_facing_direction():
	return FacingDirection

func handle_movement(delta):
	# Movement Physics
	var dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity = dir.normalized() * Speed * SpeedMultiplier * delta
	move_and_slide()
	
	# Movement Anim
	if !dir.is_zero_approx():
		$AnimatedSprite2D.play("move")
	elif dir.is_zero_approx():
		$AnimatedSprite2D.play("idle")
	
	# Update facing direction
	if(dir.is_zero_approx()):
		FacingDirection = dir.normalized()

func give_xp(xp):
	CurrentXP += xp
	print("Current XP = " + CurrentXP)
