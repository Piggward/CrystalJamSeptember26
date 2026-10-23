extends AnimationPlayer

func _ready():
	GameManager.hit.connect(func(): play("hit"))
