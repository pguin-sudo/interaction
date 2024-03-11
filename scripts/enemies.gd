extends Node2D

func get_neighbors(pos: Vector2, radius: float):
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = radius
	var detection_area = Area2D.new()
	detection_area.add_child(collision_shape)
	add_child(detection_area)
	detection_area.global_position = pos
	
	await get_tree().create_timer(0.1).timeout
	
	var overlapping_bodies = detection_area.get_overlapping_bodies()
	var enemies = []
	
	for body in overlapping_bodies:
		if body.has_method("enemy"):
			enemies.append(body)
	detection_area.queue_free()
	return enemies
