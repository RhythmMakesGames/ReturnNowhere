extends CharacterBody2D

# remove later ig
@export var disable_movement:bool = false

@export var max_move_speed = 150
@export var max_move_speed_air = 200.0
@export var max_jump_velocity = -280.0
@export var max_drop_velocity = 500.0
@export var scratch_down_speed = 25.0

@export var friction = 50
@export var acceleration_h = 250

## factor by which horizontal velocity exponentially decays
## while player is in air, and move key isn't held
@export var velocity_decay_air_h = 0.96

@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer = $JumpBuffer
var was_on_floor = false

# animation/visual
@onready var animation_player = $AnimationPlayer
@onready var player_sprite = $Sprite2D
var is_horizontally_flipped = false
var last_move_direction_h = 0

var current_state
var is_jump_key_held

# becomes idle after a few seconds of inactivity
@onready var idle_timer = $IdleTimer
var is_idle

#literals
var stand_animation:String = "standing"
var run_animation:String = "run"

var idle1_animation:String = "idle1"
var idle2_animation:String = "idle2"
var idle3_animation:String = "idle3"
var idle4_animation:String = "idle4"

var jump_action:String = "jump"
var move_left_action:String = "move_left"
var move_right_action:String = "move_right"

# basic state machine (not really ig)
enum STATES {
	STATE_ON_GROUND,
	STATE_IN_AIR,
	#STATE_ON_WALL
}

var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	# cat should be slightly above the ground when the game starts
	current_state = STATES.STATE_IN_AIR
	
func _process(delta: float) -> void:
	player_sprite.flip_h = true if is_horizontally_flipped else false
	
	match current_state:
		STATES.STATE_ON_GROUND:
			animation_player.set_speed_scale(1)
			if abs(velocity.x) > 0:
				animation_player.play(run_animation)
			else:
				if is_idle:
					# when player becomes idle (stand -> idle)
					if animation_player.assigned_animation == stand_animation:
						animation_player.set_current_animation(idle1_animation)
					
					# play idle animations at random
					var rand_anim = randi()%100
					if !animation_player.is_playing():
						if rand_anim < 30:
							animation_player.play(idle1_animation)
						elif rand_anim >= 30 && rand_anim < 90:
							animation_player.play(idle2_animation)
						elif rand_anim >= 90 && rand_anim < 95:
							animation_player.play(idle3_animation)
						elif rand_anim >= 95 && rand_anim < 100:
							animation_player.play(idle4_animation)
				else:
					animation_player.play(stand_animation)
		STATES.STATE_IN_AIR:
			# there is no jump animation, trick the player
			animation_player.set_speed_scale(0.25)
			animation_player.play(run_animation)

func _on_idle_timer_timeout() -> void:
	is_idle = true
	
func jump() -> void:
	velocity.y += max_jump_velocity
	jump_buffer.stop()
	is_jump_key_held = true

func _physics_process(delta: float) -> void:
	var move_direction := Input.get_axis(move_left_action, move_right_action)
	# holding move key (not 0)
	if move_direction:
		is_horizontally_flipped = true if move_direction < 0 else false
		
	match current_state:
		# on floor / coyote period
		STATES.STATE_ON_GROUND:
			# landed on / left the floor in the previous move call
			if ( was_on_floor != is_on_floor() ) && !is_on_floor():
				coyote_timer.start()
			
			if !is_on_floor() && coyote_timer.is_stopped():
				current_state = STATES.STATE_IN_AIR
				velocity.y = gravity * delta
			elif Input.is_action_just_pressed(jump_action) || !jump_buffer.is_stopped():
				current_state = STATES.STATE_IN_AIR
				jump()
			
			if move_direction:
				velocity.x = max_move_speed * move_direction
			else:
				velocity.x = move_toward(velocity.x, 0, friction)
			
			# idle check
			if velocity.x == 0 && velocity.y == 0:
				if idle_timer.is_stopped() && !is_idle:
					idle_timer.start()
			else:
				idle_timer.stop()
				is_idle = false

		STATES.STATE_IN_AIR:
			if Input.is_action_just_released(jump_action):
				is_jump_key_held = false
			elif Input.is_action_just_pressed(jump_action):
				jump_buffer.start()
			
			if is_on_floor():
				is_jump_key_held = false
				current_state = STATES.STATE_ON_GROUND
				
				if move_direction:
					velocity.x = max_move_speed * move_direction
				else:
					velocity.x = move_toward(velocity.x, 0, friction)
			
			#elif is_on_wall_only() && velocity.y >= 0 && Input.is_action_pressed(jump_action):
				## skip a frame. no movement update (negligible)
				#current_state = STATES.STATE_ON_WALL
			else:
				if velocity.y < max_drop_velocity:
					velocity.y += gravity * delta
				
				if move_direction:
					velocity.x += acceleration_h * delta * move_direction
					velocity.x = clamp(velocity.x, -max_move_speed_air, max_move_speed_air)
				else:
					velocity.x *= velocity_decay_air_h
		
		#STATES.STATE_ON_WALL:
			## scratching down a wall (while holding space)
			#if Input.is_action_pressed(jump_action):
				#velocity.y += gravity * delta
				#velocity.y = clampf(velocity.y, max_jump_velocity, scratch_down_speed)
				##velocity.x = -get_wall_normal().x * max_move_speed_air # not slip off
			#else:
				#velocity.x = get_wall_normal().x * max_move_speed_air
				#velocity.y = max_jump_velocity
				#move_direction = get_wall_normal().x
				#current_state = STATES.STATE_IN_AIR

	print(velocity.x)
	
	# keeping track of current information
	was_on_floor = is_on_floor()
	last_move_direction_h = move_direction
	
	## remove this later!
	if !disable_movement:
		move_and_slide()
		
	## Reset position for testing: press 4
	if Input.is_action_pressed("reset_position"):
		velocity.x = 0
		position = Vector2(57, 67)
		current_state = STATES.STATE_IN_AIR
		
	#if is_on_wall_only():
	# if was on wall and release space (becomes walljump) within a walljump timer
