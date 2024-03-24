extends Node

## Libs
var rng = RandomNumberGenerator.new()

var enemy_res: String = "res://scenes/enemy_based.tscn"
var enemies: int = 0
var max_enemies: float = 100.0 ## KOSTYL
var min_radius: float = 1100.0
var max_radius: float = 1500.0
var score_points: int = 75

@onready var player: Player = get_tree().current_scene.get_node("Player")

func _ready():
	set_process(true)
	while true:
		max_enemies = max_enemies * 1.01
		await get_tree().create_timer(5, false).timeout
		check_enemy_count()

func check_enemy_count():
	while enemies < max_enemies:
		spawn_enemy()
		await get_tree().create_timer(30.0 / enemies - max_enemies, false).timeout
		
func spawn_enemy():
	var radius = randf_range(min_radius, max_radius)
	var x = randf_range(-radius, radius)
	var y = sqrt(radius**2 - x**2)
	if randi_range(0, 1) == 0:
		y = -y
	var position = player.global_position + Vector2(x, y)
	var enemy: EnemyBased = load(enemy_res).instantiate()
	enemy.global_position = position
	enemy.player = player
	enemy.death_signal.connect(_on_enemy_death)
	get_tree().current_scene.add_child(enemy)
	enemies += 1

func _on_enemy_death(by_player: bool):
	if by_player: 
		player.add_score_points(int(score_points))
	enemies -= 1
	check_enemy_count()
