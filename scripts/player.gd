extends CharacterBody2D

## Libs
var rng = RandomNumberGenerator.new()

## Enemies
var enemy_inatack_range = true
var atacking_enemies = []

## Initial Constants
const INITIAL_HEALTH = 100.0
const INITIAL_REGENERATION = 1.0
const INITIAL_DAMAGE = 1
const INITIAL_PROTECTION = 0.2
const INITIAL_SPIKES = 0.1
const INITIAL_SPEED = 300.0
# const INITIAL_RECHARGE_SPEED = 1.0
const INITIAL_DURATION_OF_SPELLS = 1.0
const INITIAL_SPELL_SIZE = 1.0
const INITIAL_CRITICAL_STRIKE_POWER = 1.5
const INITIAL_CRITICAL_HIT_CHANCE = 0.05
const INITIAL_CHARACTER_SIZE = 1.0
const INITIAL_ENLIGHTENMENT = 1.0

## Coefficients - Adjust these to scale the effects of various stats
var health_coefficient = 1.0
var regeneration_coefficient = 1.0
var damage_coefficient = 1.0
var protection_coefficient = 1.0
var spikes_coefficient = 1.0
var speed_coefficient = 1.0
var recharge_speed_coefficient = 1.0
var duration_of_spells_coefficient = 1.0
var spell_size_coefficient = 1.0
var critical_strike_power_coefficient = 1.0
var critical_hit_chance_coefficient = 1.0
var character_size_coefficient = 1.0
var enlightenment_coefficient = 1.0

## Increases - These can be used to apply buffs or temporary modifiers
var health_increase = 0.0
var regeneration_increase = 0.0
var damage_increase = 0.0
var protection_increase = 0.0
var spikes_increase = 0.0
var speed_increase = 0.0
var recharge_speed_increase = 0.0
var duration_of_spells_increase = 0.0
var spell_size_increase = 0.0
var critical_strike_power_increase = 0.0
var critical_hit_chance_increase = 0.0
var character_size_increase = 0.0
var enlightenment_increase = 0.0

## Skills
var swarn_damage = 10 

## Current Stats
var health_current = INITIAL_HEALTH * health_coefficient + health_increase 

func player():
	pass
	
func move():
	var horizontal = Input.get_axis("ui_left", "ui_right")
	var vertical = Input.get_axis("ui_up", "ui_down")
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
	health_current += (INITIAL_REGENERATION * regeneration_coefficient + regeneration_increase) * delta
	health_current = min(health_current, INITIAL_HEALTH * health_coefficient + health_increase)

func check_damage():
	for enemy in atacking_enemies:
		if enemy == null:
			continue
		var _attack_info = enemy.get_attack_info()
		if _attack_info != null:
			enemy.take_damage(take_damage(_attack_info))

func cast():
	return
	if atacking_enemies == []:
		return
		
	var target = null
	for enemy in atacking_enemies:
		if enemy == null:
			continue
		elif target == null:
			target = enemy
		elif position.distance_to(target.position) > position.distance_to(enemy.position):
			target = enemy
			
	if target != null:
		var critical_hit_chance = INITIAL_CRITICAL_HIT_CHANCE * critical_hit_chance_coefficient + critical_hit_chance_increase
		
		var damage = INITIAL_DAMAGE * damage_coefficient + damage_increase
		if rng.randf_range(0, 1) < critical_hit_chance:
			damage = damage * INITIAL_CRITICAL_STRIKE_POWER * critical_strike_power_coefficient + critical_strike_power_increase
			target.take_damage(damage, true)
			return
		target.take_damage(damage)
		

func _physics_process(delta):
	move()
	check_health(delta)
	check_damage()
	cast()
	

func take_damage(damage, is_critical = false):
	var actual_damage = damage * (1 - (INITIAL_PROTECTION * protection_coefficient + protection_increase))
	health_current -= actual_damage
	DamageNumbers.display_number(damage, $damage_spawn.global_position, is_critical)
	if health_current <= 0:
		die()

	return damage * (INITIAL_SPIKES * spikes_coefficient + speed_increase)

func die():
	print('Died')

func _on_player_hitbox_body_entered(body):
	if body.has_method('enemy') and body.has_method('register_enemy') and body.has_method('get_attack_info'):
		atacking_enemies.append(body.register_enemy(atacking_enemies.size()))

func _on_player_hitbox_body_exited(body):
	if atacking_enemies[body.current_id] != null and body.has_method('enemy') and body.has_method('register_enemy'):
		atacking_enemies[body.current_id] = null
		
