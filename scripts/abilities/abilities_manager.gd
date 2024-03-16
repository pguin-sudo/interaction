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
	player.score_points = player.max_score_points * 0.15
	
func add_protection(value: float):
	player.protection_coefficient *= value + 1
	
func add_damage(value: float):
	player.damage_coefficient *= value + 1
	
func level_up():
	get_tree().paused = true
	ui.level_up()

func level_up_end():
	get_tree().paused = false
	var max_score_points = player.max_score_points
	player.max_score_points = max_score_points + (max_score_points * 0.2)
	player.add_score_points(-max_score_points)
