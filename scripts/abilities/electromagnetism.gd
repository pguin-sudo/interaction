extends Ability
class_name Electromagnetism

# Libs
var rng = RandomNumberGenerator.new()

@onready var storm = %Storm
var storm_duration: float = 5.0
var storm_damage: float = 20.0
var storm_radius: float = 200.0

@onready var electrostatic_pulse_scene = load("res://scenes/magic/electromagnetism/electrostatic_pulse.tscn")
var electrostatic_pulse_radius: float = 200.0
var electrostatic_pulse_slow_duration: float = 1.0
var electrostatic_pulse_damage: float = 0.4

@onready var tesla_strike_scene = load("res://scenes/magic/electromagnetism/tesla_strike.tscn")
var tesla_strike_size: float = 20.0
var tesla_strike_duration: float = 10.0
var tesla_strike_damage: float = 20.0
var tesla_strike_speed: float = 1500.0

@onready var zap_scene = load("res://scenes/magic/electromagnetism/zap.tscn")
var zap_radius: float = 0.3
var zap_slow_duration: float = 1
var zap_damage: float = 5.0
var zap_slow_power: float = 1.0

var short_circuit_radius = 500.0

func _ready():
	cooldown = 8.0
	ui._on_electromagnetism_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()
	
	## KOSTYL
	upgrades[0] = true
	upgrades[1] = true
	upgrades[2] = true
	upgrades[3] = true
	upgrades[4] = true

func activate():
	if upgrades[0]: await electrostatic_pulse_ability()
	
	var modified_duration = storm_duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	var modified_radius = storm_radius * player.spell_size_coefficient + player.spell_size_increase
	
	if upgrades[2]: zap_ability(modified_duration, modified_radius)
	await base_ability(modified_duration, modified_radius)
	
	if upgrades[1]: tesla_strike_ability()
	if upgrades[4]: short_circuit_ability()
	
	ui._on_electromagnetism_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()
	
func base_ability(modified_duration, modified_radius):
	var modified_damage = storm_damage * player.damage_coefficient + player.damage_increase
	storm.global_scale = (Vector2(0.01, 0.01) * modified_radius)
	
	storm.visible = true
	storm.get_node('SFX').play()
	
	for i in range(int(modified_duration * 4)):
		for enemy in await Enemies.get_neighbors(global_position, modified_radius):
			enemy.take_damage(modified_damage)
			if upgrades[3] and rng.randi_range(0, 5) == 0:
				player.heal(1)
		await get_tree().create_timer(0.25, false).timeout
	
	storm.get_node('SFX').stop()
	storm.visible = false

func electrostatic_pulse_ability():
	var nearest_enemy: EnemyBased = await Enemies.get_nearest(global_position, 1500)
	if nearest_enemy != null:
		var electrostatic_pulse: ExplodableObject = electrostatic_pulse_scene.instantiate()
		player.get_parent().add_child(electrostatic_pulse)
		electrostatic_pulse.explode(nearest_enemy.global_position, electrostatic_pulse_radius * player.spell_size_coefficient + player.spell_size_increase, electrostatic_pulse_slow_duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase, electrostatic_pulse_damage * player.damage_coefficient + player.damage_increase)
		await get_tree().create_timer(0.25, false).timeout

func tesla_strike_ability():
	var x = randf_range(-1, 1)
	var y = sqrt(1**2 - x**2)
	if randi_range(0, 1) == 0:
		y = -y
	var tesla_strike: Projectile = tesla_strike_scene.instantiate()
	player.get_parent().add_child(tesla_strike)
	tesla_strike.start(global_position, tesla_strike_size * player.spell_size_coefficient + player.spell_size_increase, tesla_strike_duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase, tesla_strike_damage * player.damage_coefficient + player.damage_increase, tesla_strike_speed, Vector2(x, y))
	await get_tree().create_timer(0.25, false).timeout

func zap_ability(modified_duration, modified_radius):
	for i in range(int(modified_duration * 10)):
		var radius = randf_range(0.1, modified_radius)
		var x = randf_range(-radius, radius)
		var y = sqrt(radius**2 - x**2)
		if randi_range(0, 1) == 0:
			y = -y
		var zap: ExplodableObject = electrostatic_pulse_scene.instantiate()
		player.get_parent().add_child(zap)
		zap.explode(global_position + Vector2(x, y), zap_radius * player.spell_size_coefficient + player.spell_size_increase, zap_slow_duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase, zap_damage * player.damage_coefficient + player.damage_increase, zap_slow_power)
		await get_tree().create_timer(0.1, false).timeout

func short_circuit_ability():
	var all_enemies = await Enemies.get_neighbors(global_position, short_circuit_radius)
	var enemies = []
	while enemies.size() < 3:
		var enemy_number = rng.randi_range(0, all_enemies.size())
		all_enemies.remove_at(enemy_number)
		enemies.append(all_enemies[enemy_number])
