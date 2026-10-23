extends Node2D

const PROJECTILE = preload("uid://bfkjoxk1ixfhc")
@onready var marker_2d: Marker2D = $Marker2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var width_range: Array[float] = []
var speed = 200
var shooting = false

func _ready():
	var v = get_viewport_rect().size
	width_range.append(v.x * 0.2 + GameManager.left_margin)
	width_range.append(v.x - v.x * 0.2)
	
	var r = randf_range(0.75, 1.5)
	await get_tree().create_timer(r).timeout
	shoot()
	
func _process(delta: float) -> void:
	if shooting:
		return
	self.position.x = move_toward(position.x, width_range[0], delta * speed)
	if is_equal_approx(position.x, width_range[0]):
		width_range.append(width_range.pop_front())

func shoot():
	shooting = true
	animation_player.play("load")
	await animation_player.animation_finished
	audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player_2d.play(0.1)
	var p: Node2D = PROJECTILE.instantiate()
	p.position = marker_2d.global_position
	p.look_at(Vector2(p.position.x, get_viewport_rect().size.y / 2))
	p.dir = p.rotation + deg_to_rad(90)
	get_tree().root.add_child(p)
	await get_tree().create_timer(0.2).timeout
	shooting = false
	var r = randf_range(3.0, 4.0)
	await get_tree().create_timer(r).timeout
	shoot()
