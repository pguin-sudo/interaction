extends Node2D
class_name AbilitiesManager

@onready var player: Player = $".."
@onready var ui: UI = $"../Camera2D/UI"
@onready var abilities = [$ElectromagnetismAbility, $GravityAbility, $StrongInteractionAbility, $WeakInteractionAbility]

func set_upgrade(ability_id: int, upgrade_id: int, status: bool):
	print(str(ability_id) + str(upgrade_id))
	abilities[ability_id].upgrades[upgrade_id] = status

func get_upgrades(ability_id: int) -> Array:
	return abilities[ability_id].upgrades

func skip():
	player.add_score_points(int(player.max_score_points * 0.15))

func add_protection(value: float):
	player.protection_coefficient *= value + 1

func add_damage(value: float):
	player.damage_coefficient *= value + 1

func level_up(level: int):
	get_tree().paused = true
	player.level += 1
	ui.level_up(level, abilities)

func level_up_end():
	get_tree().paused = false
	var max_score_points = player.max_score_points
	player.max_score_points = int(max_score_points + (max_score_points * 0.2))
	player.add_score_points(-max_score_points)
