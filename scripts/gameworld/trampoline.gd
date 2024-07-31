extends Area2D

@export var jump_boost = 200


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity.y = -jump_boost
