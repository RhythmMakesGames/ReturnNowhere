extends Control


var options_scene := "res://scenes/menu/ui_options_menu.tscn"


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	queue_free.call_deferred()


func _on_options_button_pressed() -> void:
	var options = load(options_scene).instantiate()
	add_child(options)
	# options spawns at an offset with it's center at top left
	options.position = Vector2(0, 0)


func _on_quit_to_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(Global.main_menu_scene)


# no idea why else part is causing this error spam:
# add: Condition "p_elem->_root" is true.
# adding a small delay fixed it
func _input(event: InputEvent) -> void:
	# toggle pause while in a level
	if Input.is_action_just_pressed("ui_cancel"):
		var options = get_node_or_null("OptionsMenu")
		if options != null:
			#print("closed options")
			options.queue_free.call_deferred()
		else:
			#print("closed pause menu")
			await get_tree().create_timer(0.01).timeout
			_on_resume_button_pressed.call_deferred()


func _on_tree_exiting() -> void:
	# fix the bug where the tree is paused, but the node is removed (eg. during scene transition)
	get_tree().paused = false
	#$"../../Player"
