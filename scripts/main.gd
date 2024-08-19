extends Node2D

var main_menu_scene = preload("res://scenes/menu/ui_main_menu.tscn")

func _ready() -> void:
	get_tree().change_scene_to_packed.call_deferred(main_menu_scene)
