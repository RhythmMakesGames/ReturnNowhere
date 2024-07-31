extends CharacterBody2D
class_name Player

@export var disable_physics:bool = false
## disable player movement controls (move, jump, etc..)
@export var disable_movement:bool = false
@onready var spawn_position = Vector2(position.x, position.y)

## for stair/obstacle stepping
@onready var raycast_step_top = $StepTop as RayCast2D
@onready var raycast_step_bottom = $StepBottom as RayCast2D
@onready var raycast_obstacle_height = $StepMeasure as RayCast2D

## max height of an obstacle that the player can step up on
@export var max_step_height = 8.0
var step_tp_factor = 40
var step_tp_offset = 0.2

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity = 980
@export var max_move_speed_ground = 140
@export var max_move_speed_air = 250.0
@export var max_jump_velocity = -300.0
@export var max_drop_velocity = 500.0
@export var scratch_down_speed = 25.0

@export var acceleration_air_h = 250
@export var acceleration_ground_h = 2500

## Note: Only applied when there is no user input.
@export var friction = 3125
## Note: Only applied when there is no user input. 
## has direct impact on velocity clamping while in air
@export var air_resistance = 250

## x times faster deceleration during change of direction
@export var turn_decel_factor = 10

## factor by which horizontal velocity exponentially decays
## while player is in air, and move key isn't held
#@export var velocity_decay_air_h = 0.96

@onready var coyote_timer = $CoyoteTimer as Timer
@onready var jump_buffer = $JumpBuffer as Timer

# becomes idle after a few seconds of inactivity
@onready var idle_timer = $IdleTimer as Timer
var is_idle

var is_jump_key_held #notimplemented
var disable_jump = false
var was_on_floor = false
var was_on_wall = false

var move_direction = 0
var last_move_direction_h = 0
var is_horizontally_flipped = false

# appearance
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var player_sprite = $Sprite2D as Sprite2D

var default_color = Color(0.76, 0.76, 0.76)
var damage_color = Color(0.76, 0.24, 0.24)

@onready var particles_jump = $JumpParticles as Node2D
@onready var particles_turn_ground = $TurnParticlesGround as Node2D
@onready var death_particles = $DeathParticles as Node2D
@onready var torch = $Torch

# literals
var stand_animation:String = "standing"
var run_animation:String = "run"

var idle1_animation:String = "idle1"
var idle2_animation:String = "idle2"
var idle3_animation:String = "idle3"
var idle4_animation:String = "idle4"

var jump_action:String = "jump"
var move_left_action:String = "move_left"
var move_right_action:String = "move_right"

# basic state machine (not really)
enum STATES {
	ON_GROUND,
	IN_AIR,
	#ON_WALL,
}
var current_state
var previous_state


func _ready() -> void:
	# cat should be slightly above the ground when it spawns
	current_state = STATES.IN_AIR
	raycast_step_top.position.y = -max_step_height


func _on_idle_timer_timeout() -> void:
	is_idle = true


func _process(delta: float) -> void:
	player_sprite.flip_h = true if is_horizontally_flipped else false
	
	#print(current_state, "-", randi())
	match current_state:
		STATES.ON_GROUND:
			handle_ground_state_process(delta)
		STATES.IN_AIR:
			# there is no jump animation, trick the player
			animation_player.set_speed_scale(0.25)
			animation_player.play(run_animation)


func handle_ground_state_process(delta):
	animation_player.set_speed_scale(1)
	if abs(velocity.x) > 0:
		animation_player.play(run_animation)
	elif is_idle:
		# when player becomes idle (expect stand -> idle)
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


func jump() -> void:
	if disable_jump == true:
		return
	
	# if randi_range(0,2) == 1 && is_on_floor():
	if is_on_floor():
		particles_jump.emitting = true
	
	# trampoline superjump fix
	velocity.y = max_jump_velocity
	
	jump_buffer.stop()
	is_jump_key_held = true


func _physics_process(delta: float) -> void:
	move_direction = Input.get_axis(move_left_action, move_right_action)
	
	if disable_physics == true:
		return
	
	if disable_movement == true:
		move_direction = 0

	# holding move key (not 0)
	if move_direction:
		# condition remains unchanged if move_direction is 0
		is_horizontally_flipped = true if move_direction < 0 else false
	
	# update variables? and stuff
	if is_horizontally_flipped:
		raycast_step_top.rotation_degrees = 180
		raycast_step_bottom.rotation_degrees = 180
	else:
		raycast_step_top.rotation_degrees = 0
		raycast_step_bottom.rotation_degrees = 0
	
	match current_state:
		# on floor / coyote period
		STATES.ON_GROUND:
			handle_ground_state_physics(delta)
		STATES.IN_AIR:
			handle_air_state_physics(delta)
		#STATES.ON_WALL:
	
	## keeping track of current information for the next iteration
	was_on_floor = is_on_floor()
	was_on_wall = is_on_wall()
	last_move_direction_h = move_direction
	previous_state = current_state
	
	#print(velocity.x)
	move_and_slide()
	
	## Reset position for testing: press 4
	if Input.is_action_pressed("reset_position"):
		velocity.x = 0
		position = spawn_position
		current_state = STATES.IN_AIR


func handle_ground_state_physics(delta):
	# landed on / left the floor in the previous move call
	if ( was_on_floor != is_on_floor() ) && !is_on_floor():
		coyote_timer.start()
	
	if !is_on_floor() && coyote_timer.is_stopped():
		current_state = STATES.IN_AIR
	elif Input.is_action_just_pressed(jump_action) || !jump_buffer.is_stopped():
		current_state = STATES.IN_AIR
		jump()
	
	# horizontal movement
	if move_direction == 0:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		#velocity.x += acceleration_ground_h * delta * move_direction
		#velocity.x = clamp(velocity.x, -max_move_speed_ground, max_move_speed_ground)
		
		if move_direction * velocity.x >= 0:
			velocity.x += acceleration_ground_h * delta * move_direction
			if abs(velocity.x) > max_move_speed_ground:
				velocity.x = move_toward(velocity.x, max_move_speed_ground * move_direction, friction * delta)
				
			# stair stepping
			if raycast_step_bottom.is_colliding() && !raycast_step_top.is_colliding():
				if !was_on_wall:
					raycast_obstacle_height.position.y = raycast_step_bottom.position.y
				
				raycast_obstacle_height.position.y -= step_tp_factor * delta
				if !raycast_obstacle_height.is_colliding():
					position.y += raycast_obstacle_height.position.y - step_tp_offset
				
				# fix double jump coyote bug
				#current_state = STATES.IN_AIR
			
		else:
			velocity.x = move_toward(velocity.x, 0, turn_decel_factor * friction * delta)

		# particles (cutting)
		if move_direction != last_move_direction_h && velocity.y == 0:
			particles_turn_ground.emitting = true
			particles_turn_ground.scale.x = 1 * move_direction
	
	# idle check
	if velocity.x == 0 && velocity.y == 0 && current_state == STATES.ON_GROUND:
		if idle_timer.is_stopped() && !is_idle:
			idle_timer.start()
	else:
		idle_timer.stop()
		is_idle = false


func handle_air_state_physics(delta):
	if previous_state == STATES.ON_GROUND:
		idle_timer.stop()
		is_idle = false
		
	if Input.is_action_just_released(jump_action):
		is_jump_key_held = false
	elif Input.is_action_just_pressed(jump_action):
		jump_buffer.start()
	
	# one frame delay in any action. no movement update (negligible)
	if is_on_floor():
		is_jump_key_held = false
		current_state = STATES.ON_GROUND
	
	#elif is_on_wall_only() && velocity.y >= 0 && Input.is_action_pressed(jump_action):
		#current_state = STATES.ON_WALL
	else:
		if velocity.y < max_drop_velocity:
			velocity.y += gravity * delta
		
		# horizontal movement
		if move_direction == 0:
			#velocity.x *= velocity_decay_air_h
			velocity.x = move_toward(velocity.x, 0, air_resistance * delta)
		else:
			#velocity.x += acceleration_air_h * delta * move_direction
			#velocity.x = clamp(velocity.x, -max_move_speed_air, max_move_speed_air)
			
			if move_direction * velocity.x >= 0:
				velocity.x += acceleration_air_h * delta * move_direction
				if abs(velocity.x) > max_move_speed_air:
					velocity.x = move_toward(velocity.x, move_direction * max_move_speed_air, air_resistance * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, turn_decel_factor * air_resistance * delta)


#func handle_wall_state_physics(delta):
		## scratching down a wall (while holding space)
	#if Input.is_action_pressed(jump_action):
		#velocity.y += gravity * delta
		#velocity.y = clampf(velocity.y, max_jump_velocity, scratch_down_speed)
		##velocity.x = -get_wall_normal().x * max_move_speed_air # not slip off
	#else:
		#velocity.x = get_wall_normal().x * max_move_speed_air
		#velocity.y = max_jump_velocity
		#move_direction = get_wall_normal().x
		#current_state = STATES.IN_AIR

#if is_on_wall_only():
# if was on wall and release space (becomes walljump) within a walljump timer


func die():
	#print(get_tree().current_scene.name)
	
	# damage effect, and death particles
	player_sprite.modulate = damage_color
	death_particles.emitting = true
	await get_tree().create_timer(0.1).timeout
	player_sprite.visible = false
	
	# particles remain for a while
	torch.visible = false
	disable_movement_controls()
	await get_tree().create_timer(0.1).timeout
	death_particles.emitting = false
	
	# respawn/wait time
	await get_tree().create_timer(0.3).timeout
	
	# reset
	torch.visible = true
	player_sprite.modulate = default_color
	player_sprite.visible = true
	reset_player()


func reset_player():
	current_state = STATES.IN_AIR
	position = spawn_position
	velocity = Vector2(0, 0)
	enable_movement_controls()


func disable_movement_controls():
	disable_movement = true
	disable_jump = true


func enable_movement_controls():
	disable_movement = false
	disable_jump = false
