extends CharacterBody2D

# remove later ig
@export var disable_movement:bool = false

@export var max_move_speed = 150
@export var max_move_speed_air = 200.0
@export var max_jump_velocity = -280.0
@export var max_drop_velocity = 500.0
@export var scratch_down_speed = 25.0

## prevent sliding
@export var friction = 50

## horizontal acceleration (magnitude)
@export var accel_initial_h:float = 50
@export var accel_decay_rate_h = 0.5 # .0 to prevent integer division
var acceleration_h:float = 0 # shouldn't be -ve
# horizontal deceleration
@export var decel_initial_h:float = 1
@export var decel_growth_rate_h = 1.04
var deceleration_h:float = 0
# keep value of last overall horizontal move input direction
var last_move_direction_h = 0

# vertical acceleration

@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer = $JumpBuffer
var is_jumping = true
var is_horizontally_flipped = false
var was_on_floor = false

# animation/states ig
var is_idle = false
@onready var animation_player = $AnimationPlayer

var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(is_horizontally_flipped):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	
	#if is_idle:
		#animation_player.play("idle_1")
	if abs(velocity.x) > 0:
		animation_player.play("run_1")
	else:
		animation_player.play("idle_2")

func _physics_process(delta: float) -> void:
	#move_and_slide()
	#print(velocity.x)
	handle_vertical_movement(delta)
	handle_horizontal_movement()
	#handle_movement_mechanics(delta)
	
	was_on_floor = is_on_floor()
	
	if !disable_movement: # remove later ig
		move_and_slide()
	
	if (was_on_floor != is_on_floor()) && !is_jumping:
		coyote_timer.start()

	# remove this later ig (for testing: press 4)
	if Input.is_action_pressed("reset_position"):
		velocity.x = 0
		position = Vector2(57, 67)
	
func handle_movement_mechanics(delta):
	# scratching down a wall (while holding space)
	if is_on_wall_only():
		if Input.is_action_pressed("jump"):
			velocity.y = clampf(velocity.y, max_jump_velocity, scratch_down_speed)
			#velocity.x = -get_wall_normal().x * max_move_speed_air # not slip off
		elif Input.is_action_just_released("jump"):
			velocity.x = get_wall_normal().x * max_move_speed_air
			velocity.y = max_jump_velocity
	
	# if was on wall and release space (becomes walljump) within a walljump timer

func handle_vertical_movement(delta):
	# vertical movement (jumping)
	if is_on_floor() || is_on_wall():
		is_jumping = false
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || !coyote_timer.is_stopped():
			jump()
			coyote_timer.stop()
		# not on floor/wall, and timer is stopped
		else: #elif !is_on_wall_only(): #no need
			jump_buffer.start()
	elif !jump_buffer.is_stopped() && is_on_floor():
		jump()
	
	## for short jumps if key released early
	#if !Input.is_action_pressed("jump") && velocity.y < 0:
		#velocity.y *= 0.8
	
	if coyote_timer.is_stopped() && !is_on_floor():
		if velocity.y < max_drop_velocity:
			velocity.y += gravity * delta

func jump() -> void:
	velocity.y += max_jump_velocity
	jump_buffer.stop()
	is_jumping = true

# and here i realized, maybe i should've used a state machine
func handle_horizontal_movement():
	# horizontal movement (walk/run/air)

	var move_direction := Input.get_axis("move_left", "move_right")
	if move_direction: # holding move key (not 0)
		if(move_direction < 0):
			is_horizontally_flipped = true
		else:
			is_horizontally_flipped = false
		
		# reset accel if change direction, or walk/land on floor
		if move_direction != last_move_direction_h || is_on_floor():
			acceleration_h = accel_initial_h
		else: # continuous movement in some direction
			# decreasing acceleration over time
			acceleration_h *= accel_decay_rate_h
		velocity.x += acceleration_h * move_direction
		
		# moving on floor, and not trying to jump
		if is_on_floor() && !Input.is_action_just_pressed("jump") || jump_buffer.is_stopped():
			velocity.x = max_move_speed * move_direction # constant walk speed
		else: # not moving on floor, or trying to jump
			velocity.x = clamp(velocity.x, -max_move_speed_air, max_move_speed_air) # variable air speed
	else: # move key released (0), deceleration/no movement
		if velocity.x == 0: # stationary
			pass
		elif is_on_floor(): # on floor, stopping force
			velocity.x = move_toward(velocity.x, 0, friction) # poorly implemented friction 
		# not on floor, deceleration (no overall input)
		elif last_move_direction_h != move_direction: # just released key
			deceleration_h = decel_initial_h
		else: # increase deceleration with time (key released some time ago)
			deceleration_h *= decel_growth_rate_h
			velocity.x -= velocity.x/abs(velocity.x) * deceleration_h # v direction * decel
	
	print(velocity.x)
	last_move_direction_h = move_direction
