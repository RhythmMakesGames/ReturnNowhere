extends Node

var main_menu_scene = preload("res://scenes/menu/ui_main_menu.tscn")

var current_scene = null
var current_level = null


func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	#var main_node = get_tree().root.get_node("Main")
