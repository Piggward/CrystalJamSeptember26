extends PanelContainer

@export var items: Array[ShopType]
@onready var label: Label = $Label

func _ready():
	label.text = items[0].description + ": " + str(items[0].cost)

func _on_button_pressed() -> void:
	items[0].apply()
	pass # Replace with function body.
