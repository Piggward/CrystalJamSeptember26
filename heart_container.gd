extends GridContainer

const HEART = preload("uid://dbik6i0tc8r7w")
const HeartContainer = preload("uid://cq1wnpouc8dwf")
@onready var heal_pickup: AudioStreamPlayer2D = $"../../HealPickup"

var next_heart = 0
func _ready():
	for i in GameManager.max_lives:
		var h = HEART.instantiate()
		add_child(h)
	GameManager.hit.connect(_on_player_hit)
	GameManager.heart_added.connect(add_heart)
	next_heart = GameManager.max_lives - 1
	
func add_heart():
	var h = HEART.instantiate()
	add_child(h)
	GameManager.player.lives += 1
	next_heart += 1
	heal_pickup.play(0.1)
	
func _on_player_hit():
	var h: Control = get_child(next_heart)
	next_heart -= 1
	var tween = create_tween()
	tween.tween_property(h, "modulate", Color(0.365, 1.0, 0.314, 0.0), 0.5)
	await tween.finished
	h.queue_free()
	
