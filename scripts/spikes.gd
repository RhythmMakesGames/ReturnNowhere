extends Area2D


func _on_body_entered(body: Node2D) -> void:
	#if body.has_method("die"):
		#body.die()
	
	# using class method
	if body is Player:
		body.die()
