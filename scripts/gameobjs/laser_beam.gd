extends Line2D

# Note:
# Do not move the 0th point (mismatch with the raycast position)
# use the transform setting to change the starting point
var player_group = "Player"

## the laser shines at discrete intervals
@export var discontinuous:bool = false
@export var emit_period:float = 2.0 			## in seconds
@export var cooldown_period:float = 1.0 			## in seconds

## the laser turns left, and right scanning the area
@export var oscillate:bool = false
@export var max_left_angle:int = 20 			## in degrees
@export var max_right_angle:int = 20 			## in degrees

@onready var raycast = $RayCast2D as RayCast2D
@onready var target_point:Vector2 = get_point_position(1)

# variables
var is_laser_on:bool = true
var elapsed_on_time:float = 0.0
var elapsed_off_time:float = 0.0
var fade_duration:float = 0.14


func _ready() -> void:
	if get_point_count() > 1:
		raycast.target_position = target_point
	else:
		queue_free()


func _physics_process(delta: float) -> void:
	if is_laser_on:
		if elapsed_on_time >= emit_period:
			elapsed_off_time = elapsed_on_time - emit_period
			elapsed_on_time = 0.0
			raycast.enabled = false
			is_laser_on = false
			modulate.a = 0
			#set_point_position(1, Vector2(0,0))
			
		elif elapsed_on_time >= emit_period - fade_duration:
			modulate.a -= delta / fade_duration
		else:
			collision_check()
			
		elapsed_on_time += delta
	else:
		if elapsed_off_time >= cooldown_period:
			elapsed_on_time = elapsed_off_time - cooldown_period
			elapsed_off_time = 0.0
			raycast.enabled = true
			is_laser_on = true
			modulate.a = 1
			
		elif elapsed_off_time >= cooldown_period - fade_duration / 2:
			modulate.a += (2 * delta) / fade_duration
		
		elapsed_off_time += delta


func collision_check():
	if raycast.is_colliding():
		set_point_position(1, to_local(raycast.get_collision_point()))
		var collider = raycast.get_collider()
		if collider.is_in_group(player_group):
			collider.die()
