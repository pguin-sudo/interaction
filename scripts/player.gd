class_name Player
extends CharacterBody2D

## Libs
var rng = RandomNumberGenerator.new()

## Enemies
var enemy_inatack_range = true
var atacking_enemies = []

## Abilities
var abilities = []

## Score Points
var level: int = 1
var score_points: int = 0
var max_score_points: int = 1000
var total_score: int = 0

## Initial Constants
const INITIAL_HEALTH = 100.0
const INITIAL_REGENERATION = 0.1
const INITIAL_PROTECTION = 1 ## KOSYIL
const INITIAL_SPIKES = 0
const INITIAL_SPEED = 300.0
const INITIAL_CRITICAL_STRIKE_POWER = 5
const INITIAL_CRITICAL_HIT_CHANCE = 0.5
const INITIAL_CHARACTER_SIZE = 1.0

## Coefficients - Adjust these to scale the effects of various stats
var health_coefficient = 1.0
var regeneration_coefficient = 1.0
var damage_coefficient = 1.0 
var protection_coefficient = 1.0
var spikes_coefficient = 1.0
var speed_coefficient = 1.0 
var cooldown_coefficient = 1.0
var duration_of_spells_coefficient = 1.0
var spell_size_coefficient = 1.0
var critical_strike_power_coefficient = 1.0
var critical_hit_chance_coefficient = 1.0
var character_size_coefficient = 1.0

## Increases - These can be used to apply buffs or temporary modifiers
var health_increase = 0.0
var regeneration_increase = 0.0
var damage_increase = 0.0
var protection_increase = 0.0
var spikes_increase = 0.0
var speed_increase = 0.0
var cooldown_increase = 0.0
var duration_of_spells_increase = 0.0
var spell_size_increase = 0.0
var critical_strike_power_increase = 0.0
var critical_hit_chance_increase = 0.0
var character_size_increase = 0.0

@onready var abilities_manager: AbilitiesManager = get_node('abilities')

## Current Stats
var health_current = INITIAL_HEALTH * health_coefficient + health_increase 
var is_dead: bool = false

## UI
@onready var ui: UI = $Camera2D/CanvasLayer/UI

func _ready():
	ui.update_health(health_current, INITIAL_HEALTH * health_coefficient + health_increase)
	ui.update_score(score_points, max_score_points, level)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_I:
		abilities_manager.level_up(level)

func player():
	pass
	
func move(horizontal = null, vertical = null):
	if horizontal == null:
		horizontal = Input.get_axis("ui_left", "ui_right") 
	if vertical == null:
		vertical = Input.get_axis("ui_up", "ui_down")
		
	if horizontal or vertical:
		velocity.x = horizontal * INITIAL_SPEED * speed_coefficient + speed_increase
		velocity.y = vertical * INITIAL_SPEED * speed_coefficient + speed_increase
	else:
		velocity.x = move_toward(velocity.x, 0, INITIAL_SPEED * speed_coefficient + speed_increase)
		velocity.y = move_toward(velocity.y, 0, INITIAL_SPEED * speed_coefficient + speed_increase)
		
	if velocity.x < 0: 
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
		
	move_and_slide()

func check_health(delta):
	if health_current < INITIAL_HEALTH * health_coefficient + health_increase:
		ui.update_health(health_current, INITIAL_HEALTH * health_coefficient + health_increase)
		health_current += (INITIAL_REGENERATION * regeneration_coefficient + regeneration_increase) * delta
	elif health_current > INITIAL_HEALTH * health_coefficient + health_increase:
		health_current = INITIAL_HEALTH * health_coefficient + health_increase
		

func check_damage():
	for enemy in atacking_enemies:
		if enemy == null:
			continue
		var _attack_info = enemy.get_attack_info()
		if _attack_info != null:
			enemy.take_damage(take_damage(_attack_info))

func _physics_process(_delta):
	move()

func _process(delta):
	check_health(delta)
	check_damage()

func take_damage(damage, is_critical = false):
	var actual_damage = damage * (1 - (INITIAL_PROTECTION * protection_coefficient + protection_increase))
	if actual_damage < 0:
		actual_damage = 0
	health_current -= actual_damage
	ui.update_health(health_current, INITIAL_HEALTH * health_coefficient + health_increase)
	DamageNumbers.display_number(actual_damage, $damage_spawn.global_position, is_critical)
	if health_current <= 0:
		die()
	if actual_damage * (INITIAL_SPIKES * spikes_coefficient + speed_increase) == 0:
		return null
	return actual_damage * (INITIAL_SPIKES * spikes_coefficient + speed_increase)
	
func heal(health):
	if health_current < INITIAL_HEALTH * health_coefficient + health_increase:
		health_current += health
		ui.update_health(health_current, INITIAL_HEALTH * health_coefficient + health_increase)
		DamageNumbers.display_number(-health, $damage_spawn.global_position)
	
func add_score_points(points: int):
	score_points += points
	total_score += points
	ui.update_score(score_points, max_score_points, level)
	if score_points >= max_score_points:
		abilities_manager.level_up(level)

func die():
	var death_sound = preload("res://sounds/death_sound.mp3")
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = death_sound
	add_child(sound_player)
	sound_player.play()

	is_dead = true
	get_tree().paused = true
	ui.die(level, total_score)

func _on_player_hitbox_body_entered(body):
	if body.has_method('enemy') and body.has_method('register_enemy') and body.has_method('get_attack_info'):
		atacking_enemies.append(body.register_enemy(atacking_enemies.size()))

func _on_player_hitbox_body_exited(body):
	if atacking_enemies[body.current_id] != null and body.has_method('enemy'):
		atacking_enemies[body.current_id] = null
		
func _on_joystick_use_move_vector(move_vector: Vector2):
	move(move_vector.x, move_vector.y)
	print(move_vector)
