# Extend
extends Node


# Variables
@export var ProjectileScene := preload("res://scenes/projectile.tscn")
@export var XPScene := preload("res://scenes/xp.tscn")
@export var MobScene := preload("res://scenes/mob.tscn")

@export var SpawnCooldown = 2

var ProjectilePool := []
var MobPool := []
var XPPool := []

var ActiveProjectileArray := []
var ActiveMobArray := []
var ActiveXPArray := []

var spawn_timer = 0

# Funcs and Defs
func _ready():
	instantiate_pools()
	get_node("player").on_level_up.connect(player_level_up)
	spawn_timer = SpawnCooldown

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0 :
		request_mob(0, Vector2(0,0))
		spawn_timer = SpawnCooldown
		
	if Input.is_action_just_pressed("toggle_vsync"):
		var current_sync = DisplayServer.window_get_vsync_mode()
		var next_sync = DisplayServer.VSYNC_ENABLED
		
		if current_sync == DisplayServer.VSYNC_ENABLED:
			next_sync = DisplayServer.VSYNC_DISABLED
		
		DisplayServer.window_set_vsync_mode(next_sync)

func request_projectile(type):
	var proj = ProjectilePool[0]
	ProjectilePool.remove_at(0)
	ActiveProjectileArray.append(proj)
	return proj

func request_mob(type, spawn_point):
	var mob = MobPool[0]
	MobPool.remove_at(0)
	ActiveMobArray.append(mob)
	
	mob.setup_mob(0, spawn_point)

func request_xp(value, position):
	var xp = XPPool[0]
	XPPool.remove_at(0)
	ActiveXPArray.append(xp)
	return xp.setup(value, position)

func free_xp(xp_to_free):
	ActiveXPArray.erase(xp_to_free)
	XPPool.append(xp_to_free)

func free_projectile(projectile_to_free):
	ActiveProjectileArray.erase(projectile_to_free)
	ProjectilePool.append(projectile_to_free)

func free_mob(mob_to_free):
	ActiveMobArray.erase(mob_to_free)
	MobPool.append(mob_to_free)

func instantiate_pools():
	for i in 1000:
		var projectile = ProjectileScene.instantiate()
		ProjectilePool.append(projectile)
		projectile.recycle.connect(free_projectile)
		add_child(projectile)
		
		var xp = XPScene.instantiate()
		XPPool.append(xp)
		xp.recycle.connect(free_xp)
		add_child(xp)
		
		var mob = MobScene.instantiate()
		MobPool.append(mob)
		mob.recycle.connect(free_mob)
		add_child(mob)

func player_level_up(level):
	print("Player Level: ", level)

func get_player_position():
	return get_node("player").global_position
	
func get_closest_mob():
	var closestDist = 1000000000000000
	var closestMob
	var player = get_player_position()
	for mob in ActiveMobArray:
		var newDist = player.distance_to(mob.global_position)
		if newDist < closestDist:
			closestDist = newDist
			closestMob = mob
	
	return closestMob
	
func get_closest_mob_position():
	var closest_mob = get_closest_mob()
	if closest_mob :
		return closest_mob.global_position
	return Vector2(0,0)
