extends Node

const MENU_MUSIC:AudioStream = preload("res://assets/sounds/Forgotten Lullaby Synth Loop.mp3")
const GAME_MUSIC:AudioStream = preload("res://assets/sounds/synthwavehouse.ogg")
const MENU_CLICK:AudioStream = preload("res://assets/sounds/click_001.ogg")
const MENU_CLICK_2:AudioStream = preload("res://assets/sounds/click_002.ogg")
const COIN_COLLECT:AudioStream = preload("res://assets/sounds/coin_collect.mp3")
const JUMP:AudioStream = preload("res://assets/sounds/jump.mp3")
const LEVEL_COMPLETE:AudioStream = preload("res://assets/sounds/yay-6120.mp3")
const SPIKE:AudioStream = preload("res://assets/sounds/spike.mp3")
const FALLING_SPIKE:AudioStream = preload("res://assets/sounds/falling_spike.mp3")
const TRAMPOLINE:AudioStream = preload("res://assets/sounds/trampoline.mp3")
const LASER:AudioStream = preload("res://assets/sounds/laser2.mp3")
const LAND_DEFAULT:AudioStream = preload("res://assets/sounds/land.mp3")

const SFX_BUS:String = "SFX"
const MUSIC_BUS:String = "Music"

@onready var audio_players: Node = $AudioPlayers
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var step_sound_player: AudioStreamPlayer = $StepSoundPlayer


#var silence_duration:float = 0.0

# set default values for the sliders
var def_game_vol = 1.0
var def_music_vol = 0.25
var def_sfx_vol = 1


func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(def_game_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(def_music_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(def_sfx_vol))


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
			# play preferred level song if any
			var lvl_song = GameManager.level_data[scene.scene_file_path]["level_song"]
			if lvl_song == "":
				# no songs added for now (for consistency)
				play_music(GAME_MUSIC)
			else:
				var song = load(lvl_song) as AudioStream
				play_music(song)


func play_sound_effect(sound):
	for stream_player:AudioStreamPlayer in audio_players.get_children():
		if not stream_player.is_playing():
			stream_player.stream = sound
			stream_player.bus = SFX_BUS
			stream_player.play()
			break


func play_music(sound):
	music_player.stream = sound
	music_player.play()


func play_step_sounds():
	if not step_sound_player.is_playing():
		step_sound_player.play()


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
		if music_player.stream != MENU_MUSIC:
			animation_player.play("fade_out")
			await get_tree().create_timer(1).timeout
			music_player.stop()
			animation_player.play("RESET")


func on_paused():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)


func on_unpaused():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
