extends Area2D

@export_file("*.tscn") var target_level_path := ""


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# this might not be the best way to go about it
		body.disable_movement_controls()
		
		if target_level_path != "":
			ScreenTransitions.wipe_transition()
			await ScreenTransitions.transition_halfpoint
			get_tree().change_scene_to_file.call_deferred(target_level_path)
