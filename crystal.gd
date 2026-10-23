extends Node2D

@export var target: Vector2
@export var speed: float
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2
@onready var ding: AudioStreamPlayer2D = $Ding
@onready var shatter: AudioStreamPlayer2D = $Shatter

var value = 1

func _process(delta: float) -> void:
	position = position.move_toward(target, delta * speed)
	if position == target:
		self.queue_free()

func get_color():
	print(polygon_2d.color)
	return polygon_2d.color

func _ready():
	var r = randf_range(0.0, 1.0)
	if r > GameManager.get_crystal_chance("Gold"):
		polygon_2d.color = Color("#eeff50")
		gpu_particles_2d.modulate = Color("#eeff50")
		gpu_particles_2d_2.modulate = Color("#eeff50")
		value = 10
		return
	if r > GameManager.get_crystal_chance("Ruby"):
		polygon_2d.color = Color("#ff50d2")
		gpu_particles_2d.modulate = Color("#ff50d2")
		gpu_particles_2d_2.modulate = Color("#ff50d2")
		value = 5
		return
	if r > GameManager.get_crystal_chance("Silver"):
		polygon_2d.color = Color.SILVER
		gpu_particles_2d.modulate = Color.SILVER
		gpu_particles_2d_2.modulate = Color.SILVER
		value = 2
		return

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManager.crystal_picked_up(self)
	area_2d.queue_free()
	animation_player.play("die")
	shatter.pitch_scale = 0.9 + GameManager.combo * 0.1
	ding.pitch_scale = 0.8 + GameManager.combo * 0.1
	shatter.play(0.1)
	ding.play()
	await animation_player.animation_finished
	self.queue_free()
	pass # Replace with function body.
