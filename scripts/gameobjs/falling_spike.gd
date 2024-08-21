extends Area2D

var player_group = "Player"

@export var speed = 500
@onready var current_speed = 0

## The spike resets after reset_or_destroy
@export var can_respawn := false
## Wait for seconds before respawn after the node has been destroyed
@export_range(0.0, 30.0) var respawn_wait:float = 0.0 
## Time after which the node self destructs if it wanders off (nothing to collide with)
@export_range(0.0, 30.0) var self_destruct_after_seconds = 10.0

@onready var initial_position = position
@onready var is_queued_for_destroy = false


func _physics_process(delta: float) -> void:
	var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
	position.x += direction.x * current_speed * delta
	position.y += direction.y * current_speed * delta


func _on_body_entered(body: Node2D) -> void:
	#print("body entered")
	#print(body)
	if body.is_in_group(player_group):
		body.die()
		queue_for_destroy()
	# moving platform is animatablebody2d
	#elif body is TileMap || body is AnimatableBody2D:
		#queue_free()
	else:
		# collisions configured with physics layers
		queue_for_destroy()


func _on_activate_zone_body_entered(body: Node2D) -> void:
	#print("activate zone entered")
	# keep collision masks in mind
	if body.is_in_group(player_group):
		current_speed = speed
		if !is_queued_for_destroy:
			await get_tree().create_timer(self_destruct_after_seconds).timeout
			queue_for_destroy()


func queue_for_destroy():
	# prevent retrigger just in case
	if !is_queued_for_destroy:
		is_queued_for_destroy = true
	else:
		return
	
	if !can_respawn:
		queue_free.call_deferred()
	else:
		var temp = duplicate()
		$CollisionPolygon2D.set_deferred("disabled", true)
		$ActivateZone/CollisionShape2D.set_deferred("disabled", true)
		visible = false
		temp.position = initial_position
		await get_tree().create_timer(respawn_wait).timeout
		add_sibling(temp)
		queue_free.call_deferred()
