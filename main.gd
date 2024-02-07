extends Node2D

var main_menu_scene = preload("res://main_menu.tscn")
var game_scene = preload("res://game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	self.add_child(main_menu_scene.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
