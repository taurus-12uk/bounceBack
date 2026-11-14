extends Control

@onready var main= $main
func _ready():
	main.pressed.connect(_on_pressed)

func _on_pressed():
	get_tree().change_scene_to_file("res://assets/main_menu.tscn")
