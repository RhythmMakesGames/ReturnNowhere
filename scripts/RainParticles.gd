extends GPUParticles2D

@export var current_camera = Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera_position = current_camera.get_screen_center_position()
	position.x = camera_position.x
	position.y = camera_position.y
