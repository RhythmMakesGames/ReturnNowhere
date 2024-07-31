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

func _on_activate_zone_body_entered(body: Node2D) -> void:
	current_speed = speed
	await get_tree().create_timer(10).timeout
	queue_free()
