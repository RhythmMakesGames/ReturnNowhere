extends Control


var main_menu_scene = "res://scenes/menu/ui_main_menu.tscn"
const LEVEL_BUTTON = preload("res://scenes/menu/level_button.tscn")

@export_dir var levels_dir
@export_dir var thumbs_dir

@onready var grid_container = $ScrollContainer/GridContainer

func _ready() -> void:
	# Note: zero-pad the level names to avoid order issues
	if levels_dir != null:
		get_levels(levels_dir)
	else:
		print("No levels directory added.")
	
	# Note: The level scene and the thumbnail should have the same name.
	# The thumbnail should be of .png extension.
	if thumbs_dir == null:
		print("No thumbnail directory provided.")


func get_levels(path) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			#print(file_name)
			if file_name.contains(".tscn"):
				create_level_button('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		
		#for file_name in dir.get_files():
			#if file_name.contains(".tscn"):
				#create_level_button('%s/%s' % [dir.get_current_dir(), file_name], file_name)
	else:
		print("Failed to open directory.")
		DirAccess.get_open_error()


func create_level_button(lvl_path: String, lvl_name: String):
	var button = LEVEL_BUTTON.instantiate()
	button.text = lvl_name.trim_suffix(".tscn").replace('_', ' ').capitalize()
	button.level_path = lvl_path
	button.thumb_path = '%s/%s' %[thumbs_dir, lvl_name.trim_suffix(".tscn") + ".png"]
	grid_container.add_child(button)


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
