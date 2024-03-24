extends Node2D
class_name Projectile

var velocity = Vector2()
var duration: float
var size: float
var damage: float

func start(pos: Vector2, siz: float, dur: float, dam: float, speed: float, direction: Vector2):
	duration = dur
	size = siz
	damage = dam
	
	global_scale = Vector2(0.05, 0.05) * size
	global_position = pos
	velocity = direction.normalized() * speed

func _process(delta):
	if duration > 0:
		global_position += delta * velocity

		for enemy in await Enemies.get_neighbors(global_position, size):
			enemy.take_damage(damage)
			enemy.apply_slow(0.9, duration)

		duration -= delta
	else:
		queue_free()

