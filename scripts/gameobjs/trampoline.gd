extends Area2D

var player_group = "Player"

@export var jump_boost = 500


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(player_group):
		body.velocity.y = -jump_boost
		AudioManager.play_sound_effect(AudioManager.TRAMPOLINE)
