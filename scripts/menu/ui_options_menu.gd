extends Control


#@export var main_menu_scene = PackedScene
var main_menu_scene = "res://scenes/menu/ui_main_menu.tscn"


func _on_return_button_pressed() -> void:
	#get_tree().change_scene_to_packed(main_menu_scene)
	get_tree().change_scene_to_file(main_menu_scene)
