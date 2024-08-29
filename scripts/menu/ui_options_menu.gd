extends Control



func _ready() -> void:
	if get_parent().name != "PauseMenu":
		$BackgroundGlitch.visible = true


func _input(_event: InputEvent) -> void:
	# toggle pause while in a level
	if Input.is_action_just_pressed("ui_cancel"):
		queue_free.call_deferred()


func _on_return_button_pressed() -> void:
	#get_tree().change_scene_to_file(Global.main_menu_scene)
	call_deferred("queue_free")
