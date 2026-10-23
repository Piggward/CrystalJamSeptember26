extends Node2D
@onready var node_2d: Node2D = $Node2D

func _ready():
	for child in node_2d.get_children():
		child.emitting = true
		
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://node_2d.tscn")
