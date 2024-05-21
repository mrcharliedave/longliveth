# Extends
extends Area2D


# Variables
var Speed = 1000.0
var XP = 1.0
var MovementDir := Vector2()


# Delegates
signal recycle


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
	body.give_xp(XP)
	queue_free()
