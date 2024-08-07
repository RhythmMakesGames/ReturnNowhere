extends Line2D

# Note:
# Do not move the 0th point (mismatch with the raycast position)
# use the transform setting to change the starting point
var player_group = "Player"

@onready var raycast = $RayCast2D as RayCast2D
@onready var target_point:Vector2 = get_point_position(1)

func _ready() -> void:
	if get_point_count() > 1:
		raycast.target_position = target_point
	else:
		queue_free()


func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		set_point_position(1, to_local(raycast.get_collision_point()))
		var collider = raycast.get_collider()
		if collider.is_in_group(player_group):
			collider.die()
	else:
		set_point_position(1, target_point)
