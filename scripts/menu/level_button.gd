extends Button


@export_file var level_path
@export_file var thumb_path
@onready var texture = $TextureRect

# button grow on hover effect
var original_size := scale
var new_size := Vector2(1.1, 1.1)
var anim_duration := 0.1


func _ready() -> void:
	if thumb_path:
		texture.texture = load(thumb_path)
	#if level_path.contains("1"):
		#disabled = true


func _on_pressed() -> void:
	if level_path == null:
		return
	ScreenTransitions.fade_transition()
	await ScreenTransitions.transition_halfpoint
	get_tree().change_scene_to_file(level_path)	


func _on_mouse_entered() -> void:
	animate_size(new_size, anim_duration)


func _on_mouse_exited() -> void:
	animate_size(original_size, anim_duration)


func animate_size(final_size: Vector2, duration: float) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'scale', final_size, duration)
