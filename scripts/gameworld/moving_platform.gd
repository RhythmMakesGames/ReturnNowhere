extends Path2D

## time taken for one animation cycle
@export var duration = 1.0
## use for closed paths
@export var loop: bool = false

@onready var animation = $AnimationPlayer as AnimationPlayer
@onready var path = $PathFollow2D as PathFollow2D

var animation_name = "move"

func _ready() -> void:
	if not loop:
		# because 2 is the duration of our move animation
		animation.speed_scale = 2/duration
		animation.play(animation_name)
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	path.progress_ratio += delta / duration
