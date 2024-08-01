extends CharacterBody2D

var player_group = "Player"
var movable_item_group = "MovableItem"

var is_getting_pushed = false
var pushed_in_direction = 0
@export var move_speed = 2000.0
@export var friction = 50

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_getting_pushed:
		velocity.x = pushed_in_direction * delta * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	move_and_slide()


func _on_left_push_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group(player_group):
		pushed_in_direction = 1
		is_getting_pushed = true


func _on_left_push_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group(player_group):
		pushed_in_direction = 0
		is_getting_pushed = false


func _on_right_push_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group(player_group):
		pushed_in_direction = -1
		is_getting_pushed = true


func _on_right_push_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group(player_group):
		pushed_in_direction = 0
		is_getting_pushed = false
