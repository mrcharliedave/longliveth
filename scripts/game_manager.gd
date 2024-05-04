# Extend
extends Node


# Variables
@export var ProjectileScene := preload("res://scenes/projectile.tscn")
@export var XPScene := preload("res://scenes/xp.tscn")

var ProjectilePool := []
var XPPool := []
var MobArray := []


# Funcs and Defs
func _ready():
	instantiate_pools()


func _process(delta):
	pass


func instantiate_pools():
	for i in 1000:
		var projectile = ProjectileScene.instantiate()
		ProjectilePool.append(projectile)
		
		var xp = XPScene.instantiate()
		XPPool.append(xp)


func get_player_position():
	return get_tree().get_node("player").global_position
