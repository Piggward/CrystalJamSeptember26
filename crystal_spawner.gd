extends Node2D
class_name CrystalSpawner

const CRYSTAL = preload("uid://csbke3fj6u46c")

var screen_middle: Vector2
var dist = 400
var crystal_ratio: float = 5.0

func _ready():
	GameManager.crystal_spawner = self
	crystal_ratio -= GameManager.crystal_spawn_bonus
	screen_middle = get_viewport_rect().size / 2
	spawn_crystal()
	
func spawn_crystal(): 
	var c = CRYSTAL.instantiate()
	#var angle = deg_to_rad(randf_range(-35, 35))
	#angle += deg_to_rad(180) if randi() % 2 == 0 else 0
	var angle = deg_to_rad(180)
	
	var start = screen_middle + Vector2(0, dist).rotated(angle)
	var target = screen_middle - Vector2(0, dist).rotated(angle)
	var pos_offset = Vector2(randf_range(-screen_middle.x / 1.5, screen_middle.x / 2), 0)
	c.target = target + pos_offset
	add_child(c)
	c.position = start + pos_offset
	c.speed = randfn(100, 35)
	var r = randfn(crystal_ratio, 0.6) / 10
	await get_tree().create_timer(r).timeout
	spawn_crystal()
