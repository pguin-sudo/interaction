extends Node

## Libs
var rng = RandomNumberGenerator.new()

var enemy_res: String = "res://scenes/enemy_based.tscn"
var enemies: int = 0
var max_enemies: int = 10
var radius: float = 1500
var score_points: int = 1000

@onready var player: Player = get_tree().current_scene.get_node("Player")

func _ready():
	set_process(true)
	check_enemy_count()
	while true:
		max_enemies = max_enemies * 1.2
		await get_tree().create_timer(5).timeout

func check_enemy_count():
	while enemies < max_enemies:
		spawn_enemy()
		await get_tree().create_timer(10 / enemies - max_enemies).timeout
		
func spawn_enemy():
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
		player.add_score_points(score_points / max_enemies)
	enemies -= 1
	check_enemy_count()
