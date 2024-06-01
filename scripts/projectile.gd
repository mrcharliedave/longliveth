# Extend
extends Node2D


# Variables
var Speed = 200.0
var SpeedMultiplier = 1.0
var Damage = 1

var ProjectileDirection

var Lifetime = 5


# Delegates
signal recycle


# Funcs and Defs
func _ready():
	set_enabled(false)

func set_enabled(enable):
	set_physics_process(enable)
	$AnimatedSprite2D.visible = enable
	
	$Area2D/CollisionShape2D.set_disabled(!enable)
	
	if enable :
		$AnimatedSprite2D.play("default")
	else :
		$AnimatedSprite2D.stop()

func _physics_process(delta):
	global_position += ProjectileDirection * Speed * SpeedMultiplier * delta
	
	Lifetime -= delta
	
	if Lifetime <= 0 :
		projectile_die()

func get_movement_direction():
	return get_tree().root.get_node("GameRoot").get_closest_mob() - global_position

func setup_projectile(spawn, direction, damage):
	set_global_position(spawn)
	ProjectileDirection = direction.normalized()
	Damage = damage
	
	set_enabled(true)

func projectile_die():
	set_enabled(false)
	recycle.emit(self)

func _on_projectile_collision(body):
	if body.has_method("take_damage"):
		body.take_damage(Damage)
		projectile_die()


func _on_area_2d_area_entered(area):
	_on_projectile_collision(area.get_parent())
