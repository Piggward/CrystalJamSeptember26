extends Line2D
class_name ProjectileTrail

var max_points = 21
@onready var player_node: Player = $"../PlayerNode"
	
func _ready():
	GameManager.jump_finished.connect(func(): self.visible = false; clear_points())
	self.visible = false
	
func _process(delta: float) -> void:
	if not player_node: 
		if points.size() > 0:
			remove_point(0)
		return
	if not player_node.shooting:
		return
	self.visible = true
	add_point(player_node.global_position)
	if points.size() > max_points:
		remove_point(0)
