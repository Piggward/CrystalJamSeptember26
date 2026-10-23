extends AudioStreamPlayer2D

func _ready():
	GameManager.purchase_done.connect(func(): self.play(0.1))
