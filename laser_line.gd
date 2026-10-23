extends Line2D

func _ready():
	GameManager.jump_finished.connect(func(): self.rotation_degrees += 180)
