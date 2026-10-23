extends Node2D
class_name Projectile

var speed = 450
var screen_height: float
@export var dir: float

func _ready():
	await get_tree().create_timer(4.0).timeout
	self.queue_free()
	
func _process(delta: float) -> void:
	self.rotation += delta * 2
	self.position -= Vector2(0, speed*delta).rotated(dir)
	
#func move():
	#var t = create_tween()
	#var target = screen_height - (screen_height * 0.1) if position.y < screen_height/2 else 0 + (screen_height * 0.1)
	#t.set_ease(Tween.EASE_IN)
	#t.tween_property(self, "position", Vector2(self.position.x, target), 2.0)
	#var r = randf_range(0.75, 1.5)
	#await t.finished
	#await get_tree().create_timer(r).timeout
	#move()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Player:
		print("SHILED!")
		self.queue_free()
		return
	GameManager.player_hit(self)
	self.queue_free()
	pass # Replace with function body.
