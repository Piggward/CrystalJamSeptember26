extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var marker_2d_2: Marker2D = $Marker2D2
const SHOOTER = preload("uid://8ag2tmoouuxu")

var heights: Array[float] = []

func _ready() -> void:
	GameManager.jump_finished.connect(_on_jump)
	GameManager.shooter_spawner = self
	
	heights.append(marker_2d.position.y)
	heights.append(marker_2d_2.position.y) 
	
func _on_jump():
	var s = SHOOTER.instantiate()
	var y = heights.pop_front()
	heights.append(y)
	s.position = Vector2(randf_range(marker_2d.position.x, marker_2d_2.position.x), y)
	s.look_at(Vector2(s.position.x, get_viewport_rect().size.y / 2))
	add_child(s)
