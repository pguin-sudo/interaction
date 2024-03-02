extends CharacterBody2D

const DAMAGE = 15.0
const SPEED = 100
const DETECTION_RANGE = 3000

const INITIAL_COOLDOWN = 1.0
var cooldown_coefficient = 1
var cooldown_increase = 0
var current_cooldown = 0

const INITIAL_PROTECTION = 0
var protection_coefficient = 1
var protection_increase = 0

const INITIAL_health = 50
var health_coefficient = 1
var health_increase = 0
var health_current = INITIAL_health * health_coefficient + health_increase

var player_position
var taret_position
var current_id = 0

@onready var player = $"../Player"

func enemy():
	pass
	
func get_attack_info():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - current_cooldown >= INITIAL_COOLDOWN * cooldown_increase + cooldown_coefficient:
		current_cooldown = current_time
		print(DAMAGE)
		return DAMAGE
	return null
	
func register_enemy(id):
	current_id = id
	return self
	
func take_damage(damage, is_critical = false):
	var actual_damage = damage * (1 - (INITIAL_PROTECTION * protection_coefficient + protection_increase))
	health_current -= actual_damage
	DamageNumbers.display_number(damage, $damage_spawn.global_position, is_critical)
	if health_current <= 0:
		die()

func die():
	queue_free()

func _physics_process(_delta):
	player_position = player.position
	taret_position = (player_position - position).normalized()
	
	if position.distance_to(player_position) < DETECTION_RANGE:
		if position.distance_to(player_position) > 100:
			velocity = taret_position * SPEED
			move_and_slide()
	

