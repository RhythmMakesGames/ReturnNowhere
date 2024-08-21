extends CanvasLayer

var pause_menu_scene = preload("res://scenes/menu/pause_menu.tscn")
#var temp_node = null


func _input(event: InputEvent) -> void:
	# toggle pause with esc while in a level
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().get_current_scene().scene_file_path.contains('levels/level') || \
			get_tree().get_current_scene().scene_file_path.contains('testing'):
			
			if !get_tree().paused:
				get_tree().paused = true
				add_child(pause_menu_scene.instantiate())
				#temp_node = pause_menu_scene.instantiate()
				#add_child(temp_node)
			# this code will not run unless process set to always
			# so, esc only works to pause the game, does not unpause it
			else:
				get_tree().paused = false
				#if temp_node:
					#remove_child(temp_node)
