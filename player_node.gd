extends Node2D
class_name Player

var speed = 300
var travel_speed = 750
var shooting = false
var aiming = false
var sides: Array[float] = []
var height_range: Array[float] = []
var go_time = false
var lives = 1
@onready var line_2d: Line2D = $Line2D
@onready var collector_collision: CollisionShape2D = $CollectArea/CollisionShape2D
const PLAYER_DIE_PARTICLES = preload("uid://dx1rg8uw455qn")
const CHARGE = preload("uid://f4lk3qdr2fo5")
const _47313572_SCI_FI_LAUNCH_351236 = preload("uid://carff2tgh5ahy")
@onready var shoot_audio: AudioStreamPlayer2D = $Shoot
@onready var charge: AudioStreamPlayer2D = $Charge
@onready var charge_particles: GPUParticles2D = $ChargeParticles
@onready var node_2d: Node2D = $"../Node2D"
@onready var crystal_collector: Node2D = $CrystalCollector

func _ready():
	GameManager.player = self
	line_2d.visible = GameManager.has_laser
	lives = GameManager.max_lives
	travel_speed += GameManager.travel_speed_bonus
	var v = get_viewport_rect().size
	var margin = v.x * 0.05
	height_range.append(v.y * 0.2)
	height_range.append(v.y - v.y * 0.2)
	collector_collision.disabled = true
	collector_collision.visible = false
	collector_collision.scale *= GameManager.collector_area_bonus
	
	sides.append(margin + GameManager.left_margin)
	sides.append(v.x - margin) 
	
	await get_tree().create_timer(0.4).timeout
	go_time = true
	
	self.position.x = sides[0]
	#await get_tree().create_timer(2).timeout
	#GameManager.player_hit()
	
func die(by: Projectile):
	var self_dir = 1 if sides[0] > 500 else -1
	var p = PLAYER_DIE_PARTICLES.instantiate()
	get_parent().add_child(p)
	p.global_position = self.global_position
	p.emitting = true
	p.rotation = by.dir - deg_to_rad(90) - (deg_to_rad(45) * self_dir)
	self.queue_free()
	
func die2():
	self.queue_free()

func _process(delta: float) -> void:
	if not go_time:
		return
	if shooting:
		self.position.x = move_toward(position.x, sides[0], delta * travel_speed)
		if is_equal_approx(position.x, sides[0]):
			shooting = false
			collector_collision.disabled = true
			collector_collision.visible = false
			GameManager.jump_finished.emit()
		return
	
	if Input.is_action_just_pressed("ui_accept") and not shooting:
		aim(true)
		return
		
	if Input.is_action_just_released("ui_accept") and aiming:
		aim(false)
		shoot()
		return
		
	if aiming:
		return
	
	self.position.y = move_toward(position.y, height_range[0], delta * speed)
	if is_equal_approx(position.y, height_range[0]):
		height_range.append(height_range.pop_front())
		
	node_2d.position.y = self.global_position.y

func aim(value: bool):
	aiming = value
	Engine.time_scale = GameManager.slow_ratio if value else 1.0
	if value:
		charge.play()
	else:
		charge.stop()

func shoot():
	if shooting:
		return
	
	sides.push_back(sides.pop_front())
	shooting = true
	collector_collision.disabled = false
	collector_collision.visible = true
	shoot_audio.pitch_scale = randf_range(1.1, 1.3)
	shoot_audio.play(0.25)
	Engine.time_scale = 0.2
