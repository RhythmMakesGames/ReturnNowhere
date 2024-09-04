extends Area2D


signal level_complete

@export_file("*.tscn") var target_level_path := ""
# congratulations screen
@export var final_level:bool = false


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("level_complete_listeners"):
		level_complete.connect(node.on_level_complete)
	
	#var node = $"../HUD/Stopwatch"
	#level_complete.connect(node.on_level_complete)
	#node = $"../Player"
	#level_complete.connect(node.on_level_complete)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().paused = false
		# this might not be the best way to go about it
		level_complete.emit()
		
		if target_level_path != "":
			# completion wait / sound effects
			await get_tree().create_timer(2.5).timeout
			
			# transition to next level
			ScreenTransitions.wipe_transition()
			await ScreenTransitions.transition_halfpoint
			get_tree().change_scene_to_file.call_deferred(target_level_path)
		else:
			if final_level:
				await get_tree().create_timer(2.5).timeout
				# congratulations, you have completed the game screen
				return
			# if no next level, let the player roam around
			body.enable_movement_controls()
			queue_free.call_deferred()
