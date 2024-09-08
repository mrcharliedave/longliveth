# Extend
extends CharacterBody2D


# Variables
var MobType

var Speed = 2000.0
var SpeedMultiplier = 1.0

var Damage = 1

var CurrentHP
@export var MaxHP = 0.0

var XPValue = 1

var TouchCooldown = 1
var CurrentCooldown = 0.0


# Delegates
signal recycle
signal on_take_damage


# Funcs and Defs
func _ready():
	set_enabled(false)

func _physics_process(delta):
	# Update Movement
	var direction = get_movement_direction() 
	velocity = direction * Speed * SpeedMultiplier * delta

	move_and_slide()
	
	if(CurrentCooldown > 0):
		CurrentCooldown -= delta

func setup_mob(mobType, starting_position):
	global_position = starting_position
	CurrentHP = MaxHP
	set_enabled(true)

func mob_die():
	set_enabled(false)
	get_tree().root.get_node("GameRoot").request_xp(XPValue, global_position)
	recycle.emit(self)

func set_enabled(enable):
	$AnimatedSprite2D.visible = enable
	if enable :
		$AnimatedSprite2D.play("default")
	else :
		$AnimatedSprite2D.stop()
	
	$DamageArea.set_deferred("disabled", !enable)
	
	set_process(enable)
	set_physics_process(enable)

func get_movement_direction():
	var dir = get_tree().root.get_node("GameRoot").get_player_position() - global_position
	return dir.normalized()

func take_damage(damage):
	on_take_damage.emit(damage)
	CurrentHP -= damage;
	if CurrentHP <= 0 :
		mob_die()

func _on_player_touched(area):
	if area.get_parent().has_method("take_damage") && CurrentCooldown <= 0.0:
		area.get_parent().take_damage(Damage)
		CurrentCooldown = TouchCooldown
