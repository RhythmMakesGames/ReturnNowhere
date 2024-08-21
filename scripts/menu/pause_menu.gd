extends Control


var options_scene := "res://scenes/menu/ui_options_menu.tscn"


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	call_deferred("queue_free")
	#queue_free.call_deferred()


func _on_options_button_pressed() -> void:
	var options = load(options_scene).instantiate()
	add_child(options)
	# options spawns at an offset with it's center at top left
	options.position = Vector2(0, 0)


func _on_quit_to_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(Global.main_menu_scene)


#func _input(event: InputEvent) -> void:
	## toggle pause while in a level
	#if Input.is_action_just_pressed("ui_cancel"):
		#var options = get_node_or_null("OptionsMenu")
		#if options:
			##print("closed options")
			#call_deferred("options.queue_free")
		#else:
			##print("closed pause menu")
			#call_deferred("_on_resume_button_pressed")
