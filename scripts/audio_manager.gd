extends Node

const MENU_MUSIC:AudioStream = preload("res://assets/sounds/Forgotten Lullaby Synth Loop.mp3")
const GAME_MUSIC:AudioStream = preload("res://assets/sounds/synthwavehouse.ogg")

const BUS_SFX:String = "SFX"
const BUS_MUSIC:String = "Music"

@onready var audio_players: Node = $AudioPlayers
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#var silence_duration:float = 0.0


func _ready() -> void:
	pass


func play_sound_effect(sound):
	for stream_player:AudioStreamPlayer in audio_players.get_children():
		if not stream_player.is_playing():
			stream_player.stream = sound
			stream_player.bus = BUS_SFX
			stream_player.play()
			break


# play music if none playing
func _process(_delta: float) -> void:
	#if music_player.is_playing():
		#silence_duration = 0.0
	#else:
		#silence_duration += _delta
	
	var scene = get_tree().current_scene
	if scene != null && !music_player.is_playing():
		if scene.name == "MainMenu":
			play_music(MENU_MUSIC)
		elif scene.name.contains("Level"):
			play_music(GAME_MUSIC)
	

# fade out music when switched b/w level & menu
func on_scene_changing(scene):
	var scene_name
	if scene is String:
		scene_name = scene
	else: # is PackedScene
		scene_name = scene.resource_path
	
	if scene_name.contains("level"):
		if music_player.stream == MENU_MUSIC:
			animation_player.play("fade_out")
			await get_tree().create_timer(1).timeout
			music_player.stop()
			animation_player.play("RESET")
	elif scene_name.contains("menu"):
		if music_player.stream == GAME_MUSIC:
			animation_player.play("fade_out")
			await get_tree().create_timer(1).timeout
			music_player.stop()
			animation_player.play("RESET")


func play_music(sound):
	music_player.stream = sound
	music_player.play()


func on_paused():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)


func on_unpaused():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
