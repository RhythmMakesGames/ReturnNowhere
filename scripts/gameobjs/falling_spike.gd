extends Area2D

var player_group = "Player"

@export var speed = 500
@onready var current_speed = 0

## The spike resets after reset_or_destroy
@export var can_respawn := false
## Wait for seconds before respawn after the node has been destroyed
@export_range(0.01, 20.0) var respawn_wait:float = 0.01 
## Pixels after travelling which the node self destructs if it wanders off (nothing to collide with)
@export var self_destruct_after_pixels = 500.0

@onready var initial_position = position
@onready var is_disabled = false

@export var reset_after_player_death = true
@onready var respawn_timer = $RespawnTimer


func _ready() -> void:
	var player = $"../Player"
	#if player == null:
		#player = get_tree().current_scene.find_child("Player")
	player.player_died.connect(_on_player_died)
	
	respawn_timer.wait_time = respawn_wait


func _physics_process(delta: float) -> void:
	var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
	position.x += direction.x * current_speed * delta
	position.y += direction.y * current_speed * delta
	
	# if the spike has wandered off
	if initial_position.distance_to(position) > self_destruct_after_pixels:
		disable_or_respawn()


func _on_body_entered(body: Node2D) -> void:
	#print(body)
	
	# collision with player (dont respawn, disable. reset by signal)
	if body.is_in_group(player_group):
		body.die()
		disable_item()
	# tilemap, moving platform etc..
	else:
		disable_or_respawn()


func _on_activate_zone_body_entered(body: Node2D) -> void:
	#print("activate zone entered")
	# keep collision masks in mind
	if body.is_in_group(player_group):
		current_speed = speed


# not on_reset_player because we reload the level instead
# triggers 0.1 seconds after body entered
func _on_player_died() -> void:
	# don't reload spike immediately, let camera/player reset?
	await get_tree().create_timer(0.5).timeout
	
	if is_disabled && reset_after_player_death:
		reset_item()


func _on_respawn_timer_timeout() -> void:
	if is_disabled:
		reset_item()


func disable_or_respawn():
	# prevent retrigger just in case
	if is_disabled:
		return
		
	disable_item()
	
	if !can_respawn:
		return
	else:
		respawn_timer.start()


func reset_item() -> void:
	respawn_timer.stop()
	position = initial_position
	#print("reset spike position")
	$CollisionPolygon2D.set_deferred("disabled", false)
	$ActivateZone/CollisionShape2D.set_deferred("disabled", false)
	visible = true
	is_disabled = false
	current_speed = 0
	
	set_physics_process(true)


func disable_item():
	if is_disabled:
		return
	$CollisionPolygon2D.set_deferred("disabled", true)
	$ActivateZone/CollisionShape2D.set_deferred("disabled", true)
	visible = false
	is_disabled = true
	
	set_physics_process(false)
