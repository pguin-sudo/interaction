extends Sprite2D

@export var explosion_particle: PackedScene

func _ready():
	kill()

func kill():
	var particle = explosion_particle.instantiate()
	particle.position = global_position
	particle.rotation = global_rotation
	particle.emitting = true
	add_child(particle)
	await get_tree().create_timer(1, false).timeout
	queue_free()
	
