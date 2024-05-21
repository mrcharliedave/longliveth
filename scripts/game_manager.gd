# Extend
extends Node


# Variables
@export var ProjectileScene := preload("res://scenes/projectile.tscn")
@export var XPScene := preload("res://scenes/xp.tscn")
@export var MobScene := preload("res://scenes/mob.tscn")

var ProjectilePool := []
var MobPool := []
var XPPool := []

var ActiveProjectileArray := []
var ActiveMobArray := []
var ActiveXPArray := []


# Funcs and Defs
func _ready():
	instantiate_pools()
	get_node("player").on_level_up.connect(player_level_up)

func _process(delta):
	pass

func request_projectile(type):
	var proj = ProjectilePool[0]
	ProjectilePool.remove_at(0)
	ActiveProjectileArray.append(proj)
	return proj

func request_xp(value):
	var xp = XPPool[0]
	XPPool.remove_at(0)
	ActiveXPArray.append(xp)
	return xp.setup(value)

func free_xp(xp_to_free):
	ActiveXPArray.erase(xp_to_free)
	XPPool.append(xp_to_free)

func free_projectile(xp_to_free):
	ActiveXPArray.erase(xp_to_free)
	XPPool.append(xp_to_free)

func free_mob(xp_to_free):
	ActiveXPArray.erase(xp_to_free)
	XPPool.append(xp_to_free)

func instantiate_pools():
	for i in 1000:
		var projectile = ProjectileScene.instantiate()
		ProjectilePool.append(projectile)
		projectile.recycle.connect(free_projectile)
		
		var xp = XPScene.instantiate()
		XPPool.append(xp)
		xp.recycle.connect(free_xp)
		
		var mob = MobScene.instantiate()
		MobPool.append(mob)
		mob.recycle.connect(free_mob)

func player_level_up(level):
	print("Player Level: ", level)

func get_player_position():
	return get_tree().get_node("player").global_position
