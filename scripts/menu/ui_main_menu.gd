extends Control

#@export var play_scene = PackedScene
#@export var options_scene = PackedScene

var start_scene := preload("res://scenes/testing.tscn")
var options_scene := "res://scenes/menu/ui_options_menu.tscn"
var select_level_scene := "res://scenes/menu/ui_select_level.tscn"
@onready var play_button = $VBoxContainer/PlayButton


func _ready() -> void:
	#play_button.grab_focus()
	pass


func _on_start_button_pressed() -> void:
	# continue, if not running for the first time
	if Global.current_level != null:
		get_tree().change_scene_to_packed(Global.current_level)
	else:
		get_tree().change_scene_to_packed(start_scene)
		#get_tree().change_scene_to_file(start_scene)


func _on_options_button_pressed() -> void:
	#release_focus()
	#options.get_node("ReturnButton").grab_focus()
	var options = load(options_scene).instantiate()
	add_child(options)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_select_level_button_pressed() -> void:
	var select_levels = load(select_level_scene).instantiate()
	add_child(select_levels)
	
	#get_tree().change_scene_to_file(select_level_scene)
