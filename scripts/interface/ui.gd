extends CanvasLayer
class_name UI

# Libs
var rng = RandomNumberGenerator.new()

@onready var score_bar: ProgressBar = %Score
@onready var health_bar: ProgressBar = %Health

@onready var ability_manager: AbilitiesManager = get_parent().get_parent().get_node('abilities')

## Reload Progress Bars
@onready var electromagnetism: TextureProgressBar = $Control/AbilitiesCooldown/VBoxContainer/HBoxContainer/ElectromagnetismBar
@onready var gravity: TextureProgressBar = $Control/AbilitiesCooldown/VBoxContainer/HBoxContainer/GravityBar
@onready var strong_interaction: TextureProgressBar = $Control/AbilitiesCooldown/VBoxContainer/HBoxContainer/StrongInteractionBar
@onready var weak_interaction: TextureProgressBar = $Control/AbilitiesCooldown/VBoxContainer/HBoxContainer/WeakInteractionBar

@onready var level_up_panel = %LevelUp

@onready var level_up_ability_info = [%AbilityInfo, %AbilityInfo2, %AbilityInfo3, %AbilityInfo4]
@onready var damage_button: Button = %DamageButton
@onready var protection_button: Button = %ProtectionButton
@onready var skip_button: Button = %SkipButton

@onready var abilities_locale: Dictionary = preload("res://abilities_info.tres").data

@onready var ability_icons = [preload("res://sprites/interface/abilities/electromagnetism.png"), preload("res://sprites/interface/abilities/gravity.png"), preload("res://sprites/interface/abilities/strong_interaction.png"), preload("res://sprites/interface/abilities/weak_interaction.png")]

var current_upgrades = []
var current_damage_precent: int
var current_protection_precent: int
		
func level_up():
	level_up_panel.visible = true
	for i in range(4):
		var random_ability = randi() % 4
		var random_upgrade = randi() % 5
		var ability = abilities_locale['abilities'][random_ability]
		
		current_upgrades.append([random_ability, random_upgrade])
		
		level_up_ability_info[random_ability].set_info(ability['upgrades'][random_upgrade]['name'], ability['upgrades'][random_upgrade]['description'], ability_icons[random_ability])
		
		current_damage_precent = rng.randi_range(1, 10)
		current_protection_precent = 11 - current_damage_precent
		
		damage_button.text = '+ ' + str(current_damage_precent) + '% к урону'
		protection_button.text = '+ ' + str(current_protection_precent) + '% к броне'

## Level Up Buttons
func _on_skip_button_pressed():
	level_up_panel.visible = false
	ability_manager.skip()
	ability_manager.level_up_end()

func _on_damage_button_pressed():
	level_up_panel.visible = false
	ability_manager.add_damage(current_damage_precent * 0.01)
	ability_manager.level_up_end()

func _on_protection_button_pressed():
	level_up_panel.visible = false
	ability_manager.add_protection(current_protection_precent * 0.01)
	ability_manager.level_up_end()

func _on_button_0_pressed():
	level_up_panel.visible = false
	ability_manager.set_upgrade(current_upgrades[0][0], current_upgrades[0][1], true)
	ability_manager.level_up_end()
	
func _on_button_1_pressed():
	level_up_panel.visible = false
	ability_manager.set_upgrade(current_upgrades[1][0], current_upgrades[1][1], true)
	ability_manager.level_up_end()
	
func _on_button_2_pressed():
	level_up_panel.visible = false
	ability_manager.set_upgrade(current_upgrades[2][0], current_upgrades[2][1], true)
	ability_manager.level_up_end()
	
func _on_button_3_pressed():
	level_up_panel.visible = false 
	ability_manager.set_upgrade(current_upgrades[3][0], current_upgrades[3][1], true)
	ability_manager.level_up_end()

## Score
func update_score(score: int, max_score: int):
	score_bar.max_value = max_score
	score_bar.value = score
	
func update_health(health: int, max_health: int):
	health_bar.max_value = max_health
	health_bar.value = health

## On ability used
func _on_electromagnetism_used(cooldown: float):
	electromagnetism.value = 0
	var start_time = Time.get_ticks_msec()
	while electromagnetism.value < electromagnetism.max_value:
		var elapsed_time = Time.get_ticks_msec() - start_time
		var progress = elapsed_time / (cooldown * 1000)
		electromagnetism.value = lerp(0.0, electromagnetism.max_value, progress)
		await get_tree().create_timer(0.5 / Engine.get_frames_per_second(), false).timeout
		
func _on_gravity_used(cooldown):
	gravity.value = 0
	var start_time = Time.get_ticks_msec()
	while gravity.value < gravity.max_value:
		var elapsed_time = Time.get_ticks_msec() - start_time
		var progress = elapsed_time / (cooldown * 1000)
		gravity.value = lerp(0.0, gravity.max_value, progress)
		await get_tree().create_timer(0.5 / Engine.get_frames_per_second(), false).timeout
		
func _on_strong_interaction_used(cooldown):
	strong_interaction.value = 0
	var start_time = Time.get_ticks_msec()
	while strong_interaction.value < strong_interaction.max_value:
		var elapsed_time = Time.get_ticks_msec() - start_time
		var progress = elapsed_time / (cooldown * 1000)
		strong_interaction.value = lerp(0.0, strong_interaction.max_value, progress)
		await get_tree().create_timer(0.5 / Engine.get_frames_per_second(), false).timeout
		
func _on_weak_interaction_used(cooldown):
	weak_interaction.value = 0
	var start_time = Time.get_ticks_msec()
	while weak_interaction.value < weak_interaction.max_value:
		var elapsed_time = Time.get_ticks_msec() - start_time
		var progress = elapsed_time / (cooldown * 1000)
		weak_interaction.value = lerp(0.0, weak_interaction.max_value, progress)
		await get_tree().create_timer(0.5 / Engine.get_frames_per_second(), false).timeout
