extends Node2D
class_name BlackHole

func start(pos, radius, duration, damage):
	$Sprite2D.global_scale = Vector2(0.04, 0.04) * radius
	global_position = pos
	for i in range(int(duration * 2)):
		for enemy in await Enemies.get_neighbors(global_position, radius):
			enemy.take_damage(damage)
			enemy.apply_slow(0.8, duration-(i*2))
		await get_tree().create_timer(0.5, false).timeout
	queue_free()
