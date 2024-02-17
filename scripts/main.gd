extends Node2D

@export var main_menu_scene = PackedScene

func _ready() -> void:
	get_tree().change_scene_to_packed.call_deferred(main_menu_scene)
