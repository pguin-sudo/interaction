class_name EnemyBased
extends CharacterBody2D

## Libs
var rng = RandomNumberGenerator.new()

var DAMAGE = 15.0
var SPEED = 100
var DETECTION_RANGE = 3000

var INITIAL_COOLDOWN = 1.0
var cooldown_coefficient = 1
var cooldown_increase = 0
var current_cooldown = 0

var INITIAL_PROTECTION = 0
var protection_coefficient = 1
var protection_increase = 0

var INITIAL_HEALTH = 50
var health_coefficient = 1
var health_increase = 0
var health_current = INITIAL_HEALTH * health_coefficient + health_increase

var current_id = 0

var global_target = null

var player = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal death_signal(by_player)
	
func enemy():
	pass
	
func get_attack_info():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - current_cooldown >= INITIAL_COOLDOWN * cooldown_increase + cooldown_coefficient:
		current_cooldown = current_time
		return DAMAGE
	return null
	
func apply_slow(slow_amount, duration):
	if slow_amount == 1:
		var speed_before = SPEED
		SPEED = 0
		await get_tree().create_timer(duration, false).timeout
		SPEED += speed_before
	else:
		SPEED *= 1 - slow_amount
		await get_tree().create_timer(duration, false).timeout
		SPEED /= 1 - slow_amount

func apply_disorientation(duration):
	global_target = Vector2(global_position.x + rng.randf_range(-100, 100), global_position.y + rng.randf_range(-1000, 100))
	await get_tree().create_timer(duration, false).timeout
	global_target = null
	
func apply_weakness(weakness_amount, duration):
	if weakness_amount == 1:
		var damage_before = DAMAGE
		DAMAGE = 0
		await get_tree().create_timer(duration, false).timeout
		DAMAGE += damage_before
	else:
		DAMAGE *= 1 - weakness_amount
		await get_tree().create_timer(duration, false).timeout
		DAMAGE /= 1 - weakness_amount
	
func register_enemy(id):
	current_id = id
	return self
	
func take_damage(damage, is_critical = false):
	if damage == null:
		return
	var actual_damage = damage * (1 - (INITIAL_PROTECTION * protection_coefficient + protection_increase))
	health_current -= actual_damage
	DamageNumbers.display_number(damage, $damage_spawn.global_position, is_critical)
	if health_current <= 0:
		die(true)

func die(by_player: bool):
	emit_signal("death_signal", by_player)
	queue_free()
	
func knockback(direction, force):
	global_position += direction.normalized() * force

func _physics_process(_delta):
	var target_position: Vector2
	
	if global_target != null:
		target_position = (global_target - global_position).normalized()
	elif player != null:
		var player_position = player.global_position
		if global_position.distance_to(player_position) > EnemyGenerator.max_radius:
			die(false)
		target_position = (player_position - global_position).normalized()
	
	if global_position.distance_to(target_position) > 20:
		velocity = target_position * SPEED
		move_and_slide()
