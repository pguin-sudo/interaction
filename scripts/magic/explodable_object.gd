extends GPUParticles2D
class_name ExplodableObject

func explode(pos, radius, slow_duration, damage, slow_power = 0.4):
	global_scale = Vector2(0.002, 0.002) * radius
	global_position = pos
	emitting = true
	
	for enemy in await Enemies.get_neighbors(global_position, radius):
		var damge_for_distance = radius - global_position.distance_to(enemy.global_position)
		if damge_for_distance < 0:
			damge_for_distance = -damge_for_distance
		enemy.take_damage(damge_for_distance * damage)
		enemy.apply_slow(slow_power, slow_duration)
	
	await get_tree().create_timer(1, false).timeout
	queue_free()
	
