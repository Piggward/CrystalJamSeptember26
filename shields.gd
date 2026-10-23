extends Node2D
const SHIELD_AREA = preload("uid://8dpbgshb7l3o")

func _ready():
	for i in GameManager.shield_amount:
		var sa = SHIELD_AREA.instantiate()
		add_child(sa)
		sa.position = Vector2(0, 75).rotated((deg_to_rad(360) / GameManager.shield_amount) * (i + 1))

func _process(delta: float) -> void:
	self.rotation += delta * 2 
