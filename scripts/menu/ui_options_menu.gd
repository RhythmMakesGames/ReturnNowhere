extends Control


func _on_return_button_pressed() -> void:
	#get_tree().change_scene_to_file(Global.main_menu_scene)
	call_deferred("queue_free")
