extends Node2D

func _ready() -> void:
	#print_debug(current_scene)
	
	self.add_child(Global.game_scene.instantiate())
