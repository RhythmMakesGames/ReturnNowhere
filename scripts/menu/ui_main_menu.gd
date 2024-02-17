extends Control

@export var play_scene = PackedScene
@export var options_scene = PackedScene
@export var credits_scene = PackedScene


func _on_start_button_pressed() -> void:
	# first time running the game
	if Global.current_level != null:
		play_scene = Global.current_level
	get_tree().change_scene_to_packed(play_scene)


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_packed(options_scene)
	#get_tree().add_child(options)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
