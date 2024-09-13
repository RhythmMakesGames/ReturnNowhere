extends Node

const MAIN_MENU_MUSIC:AudioStream = preload("res://assets/sounds/Forgotten Lullaby Synth Loop.mp3")
const GAME_MUSIC:AudioStream = preload("res://assets/sounds/synthwavehouse.ogg")

const BUS_SFX:String = "SFX"
const BUS_MUSIC:String = "Music"

@onready var audio_players: Node = $AudioPlayers
@onready var audio_stream_player: AudioStreamPlayer = $AudioPlayers/AudioStreamPlayer


func _ready() -> void:
	#play_music(MAIN_MENU_MUSIC)
	#audio_stream_player.stream = MAIN_MENU_MUSIC
	#audio_stream_player.play()
	pass


func play_sound_effect(sound):
	for stream_player:AudioStreamPlayer in audio_players.get_children():
		if not stream_player.is_playing():
			stream_player.stream = sound
			stream_player.bus = BUS_SFX
			stream_player.play()
			break


func play_music(sound):
	for stream_player:AudioStreamPlayer in audio_players.get_children():
		if not stream_player.is_playing():
			stream_player.stream = sound
			stream_player.bus = BUS_MUSIC
			# enabled loop on the import itself (doucble click)
			#stream_player.stream.loop = true
			stream_player.play()
			break
