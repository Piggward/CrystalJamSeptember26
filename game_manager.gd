extends Node

signal jump_finished
signal crystal_added
signal hit
signal game_over
signal heart_added
signal purchase_done

var player: Player
var crystal_spawner: Node2D
var shooter_spawner: Node2D
var level: Node2D
var music: AudioStreamPlayer
var is_web_build = false

var purchases: Array[ShopType]

var crystals = 2000
var left_margin = 0
var max_lives = 5  
var travel_speed_bonus = 2000
var has_laser = false
var crystal_spawn_bonus = 4.0
var collector_area_bonus = 1.0
var shield_amount = 3
var special_value = 5
var slow_ratio = 1.0
var jumps = 35

const SCORE_LABEL = preload("uid://be06ibvxc2jj1")

var combo = 0

func can_afford(cost):
	return crystals >= cost

func transaction(shopitem: ShopType):
	crystals -= shopitem.cost
	purchases.append(shopitem)
	crystal_added.emit()
	purchase_done.emit()
	
func get_crystal_chance(s):
	match s:
		"Gold": var rj = jumps - 30; return clamp(1.0 - (rj * 0.02), 0.8, 1.1)
		"Ruby": var rj = jumps - 20; return clamp(1.0 - (rj * 0.02), 0.7, 1.1)
		"Silver": return clamp(1.0 - (jumps * 0.02), 0.6, 0.95)
	
func has_purchased(shopitem: ShopType):
	return purchases.has(shopitem)
	
func true_reset():
	crystals = 0
	left_margin = 0
	max_lives = 1
	travel_speed_bonus = 0
	has_laser = false
	crystal_spawn_bonus = 0.0
	collector_area_bonus = 1.0
	shield_amount = 0
	special_value = 5
	combo = 0
	slow_ratio = 1.0
	purchases.clear()
	jumps = 0

func _ready():
	music = AudioStreamPlayer.new()
	add_child(music)
	music.stream = preload("res://audio/Rhinoceros.mp3")
	music.volume_db = -7
	music.bus = "Music"
	music.play()
	jump_finished.connect(func(): combo = 0)

func crystal_picked_up(c):
	combo += 1
	crystals += (c.value * combo)
	crystal_added.emit()
	var sl: ScoreLabel = SCORE_LABEL.instantiate()
	sl.mod = c.get_color()
	sl.score = c.value * combo
	level.add_child(sl)
	sl.global_position = c.global_position
	
func reset():
	combo = 0
	jumps = 0
	
func player_hit(by: Node2D):
	hit.emit()
	player.lives -= 1
	if player.lives <= 0:
		player.die(by)
		game_over.emit()
	var tween = create_tween()
	Engine.time_scale = 0.1
	tween.tween_property(Engine, "time_scale", 0.1, 0.05)
	tween.tween_property(Engine, "time_scale", 1.0, 0.2)
