extends CharacterBody2D

@export var speed = 200
@export var jump_speed = -350
@export var friction = 50
#@export var acceleration = 200
var is_horizontally_flipped = false
var jump_buffer = 10

var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(is_horizontally_flipped):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_speed
	
	var move_direction := Input.get_axis("move_left", "move_right")
	
	if move_direction:
		#velocity.x += move_direction * acceleration * delta
		velocity.x = move_direction * speed
		if(move_direction < 0):
			is_horizontally_flipped = true
		else: 
			is_horizontally_flipped = false
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	move_and_slide()
	
	# remove this later ig (for testing)
	if Input.is_action_pressed("reset_position"):
		velocity.x = 0
		position = Vector2(180,152)
