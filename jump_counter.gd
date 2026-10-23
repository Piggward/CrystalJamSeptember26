extends Label

var jtext = "JUMPS: "
var win_jumps = 50
var won = false
@onready var node_2d: Node2D = $"../.."
@onready var win_container: PanelContainer = $"../WinContainer"
const HEART_DROP = preload("uid://c41byvmax110o")

func _ready():
	GameManager.jump_finished.connect(on_jump)
	self.text = jtext + str(GameManager.jumps) + " / " + str(win_jumps)
	
func on_jump():
	GameManager.jumps += 1
	self.text = jtext + str(GameManager.jumps) + " / " + str(win_jumps)
	
	if GameManager.jumps >= win_jumps:
		node_2d.process_mode = Node.PROCESS_MODE_DISABLED
		win_container.visible = true
		await get_tree().create_timer(0.7).timeout
		won = true
		return
		
	if GameManager.jumps % 10 == 0:
		spawn_heart()
		
func spawn_heart():
	var hd = HEART_DROP.instantiate()
	node_2d.add_child(hd)
	var x = get_viewport_rect().size.x / 1.5
	hd.position = Vector2(randf_range(300, x), -500)
		
func _process(delta: float) -> void:
	if won and Input.is_action_just_pressed("ui_accept"):
		node_2d.process_mode = Node.PROCESS_MODE_INHERIT
		GameManager.true_reset()
		get_tree().reload_current_scene()
