extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(Global.game_scene.resource_path)
	print(Global.game_scene.resource_path)
	# continue here

func _on_options_button_pressed() -> void:
	var options = load("res://scenes/menu/ui_options_menu.tscn").instantiate()
	get_tree().current_scene.add_child(options)
	#get_tree().add_child(options)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
