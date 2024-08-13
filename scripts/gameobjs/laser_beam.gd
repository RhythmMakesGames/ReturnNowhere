extends Line2D

# Note:
# Do not move the 0th point (mismatch with the raycast position)
# use the transform setting to change the starting point
var player_group = "Player"

## the laser shines at discrete intervals
@export var discontinuous:bool = false
@export var emit_period:float = 2.0 			## in seconds
@export var cooldown_period:float = 1.0 			## in seconds

## the laser scans the area determined by the scan angle
@export var scan_area:bool = false
@export var scan_angle:int = 60 				## in degrees
#@export var scan_period:int = 
#@export var max_left_angle:int = 20 			## in degrees
#@export var max_right_angle:int = 20 			## in degrees

@onready var raycast = $RayCast2D as RayCast2D
@onready var target_point:Vector2 = get_point_position(1)

# variables
var is_laser_on:bool = true
var elapsed_on_time:float = 0.0
var elapsed_off_time:float = 0.0
var fade_duration:float = 0.14

# fix chopped laser at collision point
var line_overlap = 1.4

func _ready() -> void:
	if get_point_count() > 1:
		raycast.target_position = target_point
	else:
		queue_free()
	
	#var tween:Tween = create_tween()
	#tween.tween_property(raycast, "rotation", scan_angle, 1000)
	#tween.tween_property(raycast, "rotation", scan_angle, 2.0)
	#tween.tween_property(raycast, "rotation", scan_angle, 2.0)


func _process(delta: float) -> void:
	# pulsate effect
	#if randi_range(0, 4) == 3:
	width = 3 + randf_range(0, 2)


func _physics_process(delta: float) -> void:
	if scan_area == true:
		pass
	
	if discontinuous:
		handle_discontinous_laser(delta)
	else:
		collision_check()


func collision_check():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var collision_point = to_local(raycast.get_collision_point())
		set_point_position(1, collision_point + collision_point.normalized() * line_overlap )
		if collider.is_in_group(player_group):
			collider.die()


func handle_discontinous_laser(delta):
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
