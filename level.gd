extends Node2D

@onready var game_over_label: Label = $CanvasLayer/GameOverLabel
@onready var start_label: Label = $CanvasLayer/StartLabel
@onready var hit_by_ball: AudioStreamPlayer2D = $HitByBall
@onready var died: AudioStreamPlayer2D = $Died
@onready var music: AudioStreamPlayer = $Music
@onready var node_2d: Node2D = $Node2D
@onready var shop: PanelContainer = $CanvasLayer/Shop
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var start_wave: AudioStreamPlayer2D = $StartWave
@onready var background_particles: GPUParticles2D = $BackgroundParticles

var game_over = false
var game_start = false

func _ready():
	start_wave.play()
	GameManager.level = self
	GameManager.game_over.connect(_on_game_over)
	GameManager.hit.connect(
		func(): 
			hit_by_ball.pitch_scale = randf_range(0.8, 0.9); 
			hit_by_ball.play(0.15))
	GameManager.game_over.connect(
		func(): 
			died.pitch_scale = randf_range(0.8, 0.9); 
			died.play(0.4))
	shop.visible = false
	start_label.visible = true
	
	if GameManager.is_web_build:
		world_environment.environment.glow_intensity = 0.8
		world_environment.environment.glow_strength = 1.0
		world_environment.environment.glow_hdr_threshold = 0.8
	
func _process(delta: float) -> void:
	if game_over and Input.is_action_just_pressed("ui_accept"):
		GameManager.reset()
		get_tree().reload_current_scene()
	if not game_start and Input.is_action_just_pressed("ui_accept"):
		start_label.visible = false
	
func _on_game_over():
	await get_tree().create_timer(1.5).timeout
	game_over = true
	shop.visible = true
