extends Area2D

@export_file("*.tscn") var target_level_path := ""


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.disable_movement = true
		
		# play transition animation
		if target_level_path != "":
			get_tree().change_scene_to_file.call_deferred(target_level_path)
