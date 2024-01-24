extends CharacterBody2D

@export var max_speed = 200
@export var max_jump_velocity = -350
@export var friction = 50
#@export var acceleration = 200

var is_horizontally_flipped = false

@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer = $JumpBuffer
var was_on_floor = false
var is_jumping = true

var temp = 0

var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(is_horizontally_flipped):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func jump():
	velocity.y = max_jump_velocity
	jump_buffer.stop()
	is_jumping = true
	
func _physics_process(delta: float) -> void:
	# vertical movement
	if is_on_floor():
		is_jumping = false
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || !coyote_timer.is_stopped():
			jump()
			coyote_timer.stop()
		else: # not on floor, and timer is stopped
			jump_buffer.start()
	elif !jump_buffer.is_stopped() && is_on_floor():
		jump()
	
	if coyote_timer.is_stopped() && !is_on_floor():
		velocity.y += gravity * delta
	
	var move_direction := Input.get_axis("move_left", "move_right")
	
	# horizontal movement
	if move_direction:
		velocity.x = move_direction * max_speed
		if(move_direction < 0):
			is_horizontally_flipped = true
		else: 
			is_horizontally_flipped = false
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	was_on_floor = is_on_floor()
	move_and_slide()
	
	if (was_on_floor != is_on_floor()) && !is_jumping:
		coyote_timer.start()

	# remove this later ig (for testing: press 4)
	if Input.is_action_pressed("reset_position"):
		velocity.x = 0
		position = Vector2(180,152)
