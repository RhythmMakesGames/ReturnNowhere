extends Label


var elapsed_time:float = 0.0

# since I'm not making levels that take hours to beat
var minutes:int = 0
var seconds:int = 0
var milliseconds:int = 0


func _process(delta: float) -> void:
	elapsed_time += delta
	milliseconds = int(fmod(elapsed_time, 1) * 1000)
	seconds = int(fmod(elapsed_time, 60))
	minutes = int(fmod(elapsed_time, 3600) / 60)
	#minutes = int(elapsed_time) / 60
	text = "%02d:" % minutes + "%02d:" % seconds + "%03d" % milliseconds


func on_level_complete():
	set_process(false)
	var level_name = get_tree().current_scene.name.replace('_', ' ')
	# save time, for the level
