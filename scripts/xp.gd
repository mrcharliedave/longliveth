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
	disable_xp()

func _process(delta):
	if !MovementDir.is_zero_approx():
		global_position += MovementDir * delta * Speed

func disable_xp():
	XP = 0
	MovementDir = Vector2(0,0)
	set_enabled(false)

func setup(xp_value, location):
	XP = xp_value
	global_position = location
	set_enabled(true)

func set_enabled(enable):
	$AnimatedSprite2D.visible = enable
	if enable :
		$AnimatedSprite2D.play("default")
	else :
		$AnimatedSprite2D.stop()
	
	$CollisionShape2D.set_deferred("disabled", !enable)
	
	set_process(enable)

func xp_collected():
	disable_xp()
	recycle.emit(self)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("give_xp") :
		body.give_xp(XP)
		xp_collected()
