extends Control

@export var tutorial_scene = PackedScene
@export var options_scene = PackedScene
@export var credits_scene = PackedScene


func _on_start_button_pressed() -> void:
	# continue, if not running for the first time
	if Global.current_level != null:
		get_tree().change_scene_to_packed(Global.current_level)
	else:
		get_tree().change_scene_to_packed(tutorial_scene)


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_packed(options_scene)
	#get_tree().add_child(options)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
