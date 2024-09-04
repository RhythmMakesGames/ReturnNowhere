extends CanvasLayer

var pause_menu_scene = preload("res://scenes/menu/pause_menu.tscn")
#var temp_node = null
@onready var player = $"../Player"
@onready var level_name = $LevelName
@onready var coins_collected = $Coins/Collected


func _ready() -> void:
	#level_name.text = get_tree().current_scene.name.replace('_', ' ')
	pass


func _input(_event: InputEvent) -> void:
	# toggle pause with esc while in a level
	if Input.is_action_just_pressed("ui_cancel"):
		if ScreenTransitions.is_screen_transitioning:
			return
		if player.is_dead:
			return
		
		if get_tree().get_current_scene().scene_file_path.contains('levels/level') || \
			get_tree().get_current_scene().scene_file_path.contains('testing'):
			
			if !get_tree().paused:
				get_tree().paused = true
				#get_tree().set_deferred("paused", true)
				add_child(pause_menu_scene.instantiate())
				#temp_node = pause_menu_scene.instantiate()
				#add_child(temp_node)
			
			# this code will not run unless process set to always
			# so, esc only works to pause the game, does not unpause it
			else:
				print("therefore, this should never print")
				get_tree().paused = false
				#get_tree().set_deferred("paused", false)
				#if temp_node:
					#remove_child(temp_node)


# save count to level data
func on_coin_collected():
	pass
