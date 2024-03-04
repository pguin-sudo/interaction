extends Node2D
class_name BlackHole

var radius = 0
var duration = 0
var damage = 0

func start(pos, rad, dur, dam):
	global_position = pos
	radius = rad
	duration = dur
	damage = dam
	for i in range(int(duration * 2)):
		for enemy in await Enemies.get_neighbors(global_position, radius):
			print(enemy)
			enemy.take_damage(damage)
			enemy.apply_slow(0.8, duration-(i*2))
		await get_tree().create_timer(0.5).timeout
	queue_free()
