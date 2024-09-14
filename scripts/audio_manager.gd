extends Node

const MENU_MUSIC:AudioStream = preload("res://assets/sounds/Forgotten Lullaby Synth Loop.mp3")
const GAME_MUSIC:AudioStream = preload("res://assets/sounds/synthwavehouse.ogg")

const BUS_SFX:String = "SFX"
const BUS_MUSIC:String = "Music"

@onready var audio_players: Node = $AudioPlayers
@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	play_music(GAME_MUSIC)
	pass


func play_sound_effect(sound):
	for stream_player:AudioStreamPlayer in audio_players.get_children():
		if not stream_player.is_playing():
			stream_player.stream = sound
			stream_player.bus = BUS_SFX
			stream_player.play()
			break


func play_music(sound):
	music_player.stream = sound
	music_player.play()


func on_paused():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)


func on_unpaused():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
