extends Node2D

var main_menu_scene = preload("res://scenes/menu/ui_main_menu.tscn")
var game_scene = preload("res://scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_child(main_menu_scene.instantiate())
	#self.add_child(game_scene.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
