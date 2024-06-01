# Extend
extends CharacterBody2D


# Delegates
signal on_level_up


# Variables
@export var Speed = 300.0
var SpeedMultiplier = 1

@export var MaxHP = 10
var CurrentHP = 10

var LevelThreshold = [0,1,5,10]
var CurrentXP = 0.0
var CurrentLevel = 0

var FacingDirection

var ActionTime = 1
var ATB = 0.0

# Funcs and Defs
func _ready():
	CurrentHP = MaxHP

func _physics_process(delta):
	handle_movement(delta)
	ATB += delta
	if(ATB >= ActionTime):
		ATB = 0
		action()

func action():
	var projectile = get_tree().root.get_node("GameRoot").request_projectile(0)
	projectile.setup_projectile(global_position, get_tree().root.get_node("GameRoot").get_closest_mob_position() - global_position, 1)

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
	if !dir.is_zero_approx() :
		FacingDirection = dir.normalized()

func give_xp(xp):
	CurrentXP += xp
	if(LevelThreshold.size() > CurrentLevel+1 && CurrentXP >= LevelThreshold[CurrentLevel+1]):
		CurrentLevel = CurrentLevel + 1
		on_level_up.emit(CurrentLevel)
		
	print("Current XP = ", CurrentXP)

func player_die():
	get_tree().reload_current_scene()

func take_damage(damage):
	CurrentHP -= damage
	print("Player HP: ", CurrentHP)
	if CurrentHP <= 0:
		player_die()
