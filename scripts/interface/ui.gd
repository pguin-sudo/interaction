extends CanvasLayer
class_name UI

# Libs
var rng = RandomNumberGenerator.new()

@onready var score_bar: ProgressBar = %Score
@onready var score_label = %ScoreLabel
@onready var health_bar: ProgressBar = %Health

@onready var clock: Label = %Clock

@onready var ability_manager: AbilitiesManager = get_parent().get_parent().get_node('abilities')

## Abilities Cooldown
@onready var abilities_cooldown = %AbilitiesCooldown

@onready var electromagnetism: TextureProgressBar = %ElectromagnetismBar
@onready var gravity: TextureProgressBar = %GravityBar
@onready var strong_interaction: TextureProgressBar = %StrongInteractionBar
@onready var weak_interaction: TextureProgressBar = %WeakInteractionBar

## Level Up
@onready var level_up_panel = %LevelUp
@onready var level_label: Label = %LevelLabel

@onready var level_up_ability_infos = [%AbilityInfo, %AbilityInfo2, %AbilityInfo3, %AbilityInfo4]
@onready var damage_button: Button = %DamageButton
@onready var protection_button: Button = %ProtectionButton
@onready var skip_button: Button = %SkipButton

@onready var abilities_locale: Dictionary = preload("res://abilities_info.tres").data
@onready var ability_icons = [preload("res://sprites/interface/abilities/electromagnetism.png"), preload("res://sprites/interface/abilities/gravity.png"), preload("res://sprites/interface/abilities/strong_interaction.png"), preload("res://sprites/interface/abilities/weak_interaction.png")]

var current_upgrades = []
var current_damage_precent: int
var current_protection_precent: int

## Death Panel
@onready var death_panel = %DeathPanel
@onready var total_level = %TotalLevel
@onready var total_score = %TotalScore
@onready var ingame_time = %IngameTime
@onready var total_time = %TotalTime


## Timer
var is_paused: bool = false
var pause_start_time: int = 0
var total_paused_time: int = 0

func _process(delta):
	if get_tree().paused != is_paused:
		is_paused = !is_paused
		if is_paused:
			pause_start_time = Time.get_ticks_msec()
		else:
			total_paused_time += Time.get_ticks_msec() - pause_start_time
			
	if !is_paused:
		var current_time = Time.get_ticks_msec()
		var elapsed_time = current_time - total_paused_time
		var minutes = str(int(elapsed_time / 60000))
		var seconds = str(int((elapsed_time / 1000) % 60))
		clock.text = minutes.pad_zeros(2) + ":" + seconds.pad_zeros(2)

func die(level: int, score: int):
	abilities_cooldown.visible = false
	death_panel.visible = true
	
	total_level.text = str(level)
	total_score.text = str(score)
	
	var current_time = Time.get_ticks_msec()
	
	var minutes = str(int(current_time / 60000))
	var seconds = str(int((current_time / 1000) % 60))
	ingame_time.text = minutes.pad_zeros(2) + ":" + seconds.pad_zeros(2)
	
	var elapsed_time = current_time - total_paused_time
	minutes = str(int(elapsed_time / 60000))
	seconds = str(int((elapsed_time / 1000) % 60))
	
	total_time.text = minutes.pad_zeros(2) + ":" + seconds.pad_zeros(2)
	
func level_up(level: int, abilities: Array):
	if current_upgrades != []: return
	level_up_panel.visible = true
	
	var errors = 0
	while current_upgrades.size() < 4 and errors < 10:
		var random_ability = randi() % 4
		var random_upgrade = randi() % 5
		var ability = abilities_locale['abilities'][random_ability]
		
		if abilities[random_ability].upgrades[random_upgrade] == true:
			errors += 1 
			continue
		
		var new_upgrade = [random_ability, random_upgrade]
		
		if new_upgrade in current_upgrades:
			errors += 1 
			continue
		
		current_upgrades.append(new_upgrade)
		level_up_ability_infos[current_upgrades.size()-1].set_info(ability['upgrades'][random_upgrade]['name'], ability['upgrades'][random_upgrade]['description'], ability_icons[random_ability])
	 
	if errors >= 10:
		var i = current_upgrades.size()
		while i < 4:
			level_up_ability_infos[i].visible = false
			i += 1
	
	current_damage_precent = rng.randi_range(1, 10)
	current_protection_precent = 11 - current_damage_precent
	
	level_label.text = 'Уровень ' + str(level)
	damage_button.text = '+ ' + str(current_damage_precent) + '% к урону'
	protection_button.text = '+ ' + str(current_protection_precent) + '% к броне'

func level_up_end():
	level_up_panel.visible = false
	current_upgrades = []
	ability_manager.level_up_end()

## Level Up Buttons
func _on_skip_button_pressed():
	level_up_end()
	ability_manager.skip()

func _on_damage_button_pressed():
	ability_manager.add_damage(current_damage_precent * 0.01)
	level_up_end()

func _on_protection_button_pressed():
	ability_manager.add_protection(current_protection_precent * 0.01)
	level_up_end()

func _on_button_0_pressed():
	ability_manager.set_upgrade(current_upgrades[0][0], current_upgrades[0][1], true)
	level_up_end()
	
func _on_button_1_pressed():
	ability_manager.set_upgrade(current_upgrades[1][0], current_upgrades[1][1], true)
	level_up_end()
	
func _on_button_2_pressed():
	ability_manager.set_upgrade(current_upgrades[2][0], current_upgrades[2][1], true)
	level_up_end()
	
func _on_button_3_pressed():
	ability_manager.set_upgrade(current_upgrades[3][0], current_upgrades[3][1], true)
	level_up_end()

## Score
func update_score(score: int, max_score: int, level):
	score_bar.max_value = max_score
	score_bar.value = score
	score_label.text = str(level)
	
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
