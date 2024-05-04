# Extends
extends Area2D


# Variables
var Speed = 1000.0
var XP
var MovementDir := Vector2()


# Funcs and Defs
func _ready():
	#disable_xp()
	pass


func _process(delta):
	if !MovementDir.is_zero_approx():
		global_position += MovementDir * delta * Speed


func disable_xp():
	XP = 0
	MovementDir = Vector2(0,0)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.hide()
	
	$CollisionShape2D.set_disabled(true)	


func setup(xp_value):
	XP = xp_value
	$AnimatedSprite2D.show()
	
	$CollisionShape2D.set_disabled(false)


func _on_body_entered(body):
	if body.get_name()  == "MagnetCollidor":
		MovementDir = Vector2(global_position - body.global_position).normalized()
	elif body.get_name() == "CollisionShape2D":
		body.give_xp(XP)
		queue_free()


func _on_body_exited(body):
	if body.get_class() == "xp_magnet":
		MovementDir = Vector2(0,0)
