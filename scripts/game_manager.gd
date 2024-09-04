extends Node

var main_menu_scene = preload("res://scenes/menu/ui_main_menu.tscn")

var current_level:String = ""
var save_path = "user://player_data.save"

# default_level_data is defined at the end of the script
var level_data:Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# load level data from previous save file
	if FileAccess.file_exists(save_path):
		# load from previous save file
		var save = FileAccess.open(save_path, FileAccess.READ)
		var json_string = save.get_line()
		var json = JSON.new()
		json.parse(json_string)
		level_data = json.get_data()
		save.close()
	else:
		# load default level data
		level_data = default_level_data
		#save_level_data_to_file()
		print("Loaded default level data.")
	
	# set current level to the last unlocked level
	for key in level_data:
		if level_data[key]["unlocked"] == true:
			current_level = key
	
	#var root = get_tree().get_root()
	#current_scene = root.get_child(root.get_child_count() - 1)
	#var main_node = get_tree().root.get_node("Main")

	#Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(64, 64))


func save_level_data_to_file():
	var save = FileAccess.open(save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(level_data)
	save.store_line(json_string)
	print("Saved level data.")


func _input(_event: InputEvent) -> void:
	 # Toggle fullscreen on F11 press
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


# HUD gets name from the scene root if not provided
var default_level_data:Dictionary = {
	"res://scenes/levels/level_01.tscn":{
		"name": "Getting Ready",
		"best_time": 0.0,
		"unlocked": true,
		"unlocks": "res://scenes/levels/level_02.tscn",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 3
	},
	"res://scenes/levels/level_02.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_03.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_04.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_05.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_06.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_07.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_08.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_09.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_10.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_11.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	},
	"res://scenes/levels/level_12.tscn":{
		"name": "",
		"best_time": 0.0,
		"unlocked": false,
		"unlocks": "",
		"completed": false,
		"coins_collected": 0,
		"coins_total": 0
	}
}
