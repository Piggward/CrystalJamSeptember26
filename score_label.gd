extends Node2D
class_name ScoreLabel

@onready var animation_player: AnimationPlayer = $Label/AnimationPlayer
@onready var label: Label = $Label

@export var score: float
@export var mod: Color

var min_size = 1
var max_size = 3

func _ready():
	if score > 20:
		label.add_theme_font_size_override("font_size", 25 * 3)
	elif score > 15: 
		label.add_theme_font_size_override("font_size", 25 * 2.5)
	elif score > 10: 
		label.add_theme_font_size_override("font_size", 25 * 2.0)
	elif score > 5: 
		label.add_theme_font_size_override("font_size", 25 * 1.5)
	label.modulate = mod
	label.text = str(int(score))
	animation_player.play("new_animation")
	await animation_player.animation_finished
	
	self.queue_free()
