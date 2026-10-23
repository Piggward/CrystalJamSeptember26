extends Control

@export var items: Array[ShopType]
@onready var cost_label: Label = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/Label
@onready var description_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
var current_index = 0
var current_item: ShopType
@onready var panel_container_2: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer2
var cd = false
@onready var h_box_container: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
const SHOP_CAPSULE_PANEL = preload("uid://cs4bio1nvm0ir")

var done_color = Color("5dff50")

func _ready():
	var to_erase = []
	var at_least_one_item = items[0]
	for i in items.size():
		var caps = SHOP_CAPSULE_PANEL.instantiate()
		h_box_container.add_child(caps)
	
	for i in items:
		if GameManager.has_purchased(i):
			to_erase.append(i)
		
	for i in to_erase:
		set_current_as_purchased()
		items.erase(i)
		
	if items.size() == 0:
		current_item = at_least_one_item
		set_labels()
		panel_container_2.visible = false
		return
		
	current_item = items.pop_front()
	set_labels()
	
	
func set_labels():
	description_label.text = current_item.description.to_upper()
	cost_label.text = str(current_item.cost)
	
func set_current_as_purchased():
	var c: Panel = h_box_container.get_child(current_index)
	var stylebox = c.get_theme_stylebox("panel").duplicate()
	stylebox.bg_color = done_color
	c.add_theme_stylebox_override("panel", stylebox)
	
	current_index += 1
	
func _on_button_pressed() -> void:
	if cd:
		return
		
	cd = true
	if not GameManager.can_afford(current_item.cost):
		return
		
	GameManager.transaction(current_item)
	current_item.apply()
	
	set_current_as_purchased()
	
	if items.is_empty():
		panel_container_2.visible = false
		return
		
	current_item = items.pop_front()
	set_labels()
	await get_tree().create_timer(0.2).timeout
	cd = false
	pass # Replace with function body.
