extends Control

var game_scene = "res://scenes/game.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)
	# continue here

func _on_options_button_pressed() -> void:
	var options = load("res://scenes/menu/ui_options_menu.tscn").instance()
	get_tree().add_child(options)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
