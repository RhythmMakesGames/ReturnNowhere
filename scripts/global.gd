extends Node

const main_menu_scene = preload("res://scenes/menu/ui_main_menu.tscn")
const game_scene = preload("res://scenes/game.tscn")

var current_scene = null


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	#print(current_scene)
	
func switch_scene(resource_path):
	call_deferred("_deferred_switch_scene", resource_path)


func _deferred_switch_scene(resource_path):
	pass
