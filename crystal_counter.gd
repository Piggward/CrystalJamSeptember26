extends Label

@export var ctext = "x "

func _ready():
	self.text = ctext + str(GameManager.crystals)
	GameManager.crystal_added.connect(_on_pickup)
	
func _on_pickup():
	self.text = ctext + str(GameManager.crystals)
