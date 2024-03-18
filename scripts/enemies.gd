extends Node

func get_neighbors(pos: Vector2, radius: float) -> Array:
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = radius
	var detection_area = Area2D.new()
	detection_area.add_child(collision_shape)
	add_child(detection_area)
	detection_area.global_position = pos
	
	await get_tree().create_timer(0.1, false).timeout
	
	var overlapping_bodies = detection_area.get_overlapping_bodies()
	var enemies = []
	
	for body in overlapping_bodies:
		if body.has_method("enemy"):
			enemies.append(body)
	detection_area.queue_free()
	return enemies

func get_nearest(pos: Vector2, radius: float) -> EnemyBased:
	var enemies: Array = await get_neighbors(pos, radius)
	var nearest_enemy: EnemyBased = null
	var nearest_distance: float = radius + 1

	for enemy in enemies:
		var dist: float = pos.distance_to(enemy.global_position)
		if dist < nearest_distance:
			nearest_enemy = enemy
			nearest_distance = dist
			
	return nearest_enemy
