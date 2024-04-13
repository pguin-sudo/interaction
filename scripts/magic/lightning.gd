extends Line2D
class_name Lightning

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var animation_player = $AnimationPlayer

var divider: float = 5
var points_lerp: Array = []
var sway_float: float
var sway_divader: float = 20
var start: EnemyBased = null
var end: EnemyBased = null

var damage: float = 5.0;

func set_start(node: EnemyBased):
	start = node
	add_point(node.global_position)

func set_end(node: EnemyBased):
	end = node
	add_point(node.global_position)

func segmetize(form_to: Vector2, start_pos: Vector2):
	points_lerp.clear()
	var distance: float = form_to.length()
	sway_float = distance/sway_divader
	sway_float = clamp(sway_float, 0, 10)
	var segment_count = distance/divider
	for point in range(0, segment_count):
		points_lerp.append(randf())
	points_lerp.sort()
	var point_index: int = 1
	for point_offset in points_lerp:
		add_point(start_pos + point_offset * form_to, point_index)
		point_index += 1

func sway(normal: Vector2):
	var point_count: int = get_point_count() - 1
	for point in point_count: 
		if point == 0 or point == point_count:
			continue
		else:
			var offset = ((get_point_position(point) + get_point_position(point - 1))/2) + normal * rng.randf_range(-sway_float, sway_float)
			set_point_position(point, offset)

func _process(delta):
	if not start or not end:
		end_charge()
	else:
		start.take_damage(damage)
		end.take_damage(damage)
		points[0] = start.global_position
		points[1] = end.global_position
		var from_to = end.global_position - start.global_position
		var normal = Vector2(from_to.y, -from_to.x).normalized()
		segmetize(from_to, start.global_position)
		sway(normal)

func end_charge():
	queue_free()
