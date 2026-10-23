extends Node2D

var drop_speed = 60
var dir = 1

func _ready():
	pendulum()
	await get_tree().create_timer(50).timeout
	self.queue_free()
	
func pendulum():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "rotation_degrees", 0, 0.75)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees", 45 * dir, 0.5)
	dir *= -1
	await tween.finished
	pendulum()
	
	
func _process(delta: float) -> void:
	self.position.y += drop_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManager.heart_added.emit()
	self.queue_free()
	pass # Replace with function body.
