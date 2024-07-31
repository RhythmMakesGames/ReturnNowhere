extends Area2D

@export var speed = 500
@onready var current_speed = 0


func _physics_process(delta: float) -> void:
	var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
	position.x += direction.x * current_speed * delta
	position.y += direction.y * current_speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
		queue_free()
	print(body)
	# moving platform is animatablebody2d
	#elif body is TileMap || body is AnimatableBody2D:
		#queue_free()
	# collisions configured with physics layers
	queue_free()

func _on_activate_zone_body_entered(body: Node2D) -> void:
	# keep collision masks in mind
	if body is Player:
		current_speed = speed
		await get_tree().create_timer(10).timeout
		queue_free()
