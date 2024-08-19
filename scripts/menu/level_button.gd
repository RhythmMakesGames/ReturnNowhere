extends Button


@export_file var level_path
@export_file var thumb_path
@onready var texture = $TextureRect


func _ready() -> void:
	if thumb_path:
		texture.texture = load(thumb_path)
	#if level_path.contains("1"):
		#disabled = true


func _on_pressed() -> void:
	if level_path == null:
		return
	get_tree().change_scene_to_file(level_path)
