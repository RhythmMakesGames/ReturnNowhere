extends Control

#@export var play_scene = PackedScene
#@export var options_scene = PackedScene

var play_scene = "res://scenes/testing.tscn"
var options_scene = "res://scenes/menu/ui_options_menu.tscn"
var select_level_scene = "res://scenes/menu/ui_select_level.tscn"


func _ready() -> void:
	$VBoxContainer/PlayButton.grab_focus()
	pass


func _on_start_button_pressed() -> void:
	# continue, if not running for the first time
	if Global.current_level != null:
		get_tree().change_scene_to_packed(Global.current_level)
	else:
		#get_tree().change_scene_to_packed(play_scene)
		get_tree().change_scene_to_file(play_scene)


func _on_options_button_pressed() -> void:
	#get_tree().change_scene_to_packed(options_scene)
	get_tree().change_scene_to_file(options_scene)
	
	# the buttons still work
	#var options = options_scene as PackedScene
	#get_tree().current_scene.add_child(options.instantiate())


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_select_level_button_pressed() -> void:
	get_tree().change_scene_to_file(select_level_scene)
