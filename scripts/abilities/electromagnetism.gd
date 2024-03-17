extends Ability
class_name Electromagnetism

# Libs
var rng = RandomNumberGenerator.new()

@onready var storm = %Storm
var storm_duration: float = 5.0
var storm_damage: float = 30.0
var storm_radius: float = 200.0

@onready var electrostatic_pulse_scene = load("res://scenes/magic/electromagnetism/electrostatic_pulse.tscn")
var discharge_damage_min: float = 10.0
var discharge_damage_max: float = 20.0

var tesla_damage: float = 100.0

var static_impulse_damage: float = 5.0

func _ready():
	cooldown = 8.0
	ui._on_electromagnetism_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func activate():
	if upgrades[0]: await electrostatic_pulse_ability()
	await base_ability()

	ui._on_electromagnetism_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()
	
func base_ability():
	var modified_duration = storm_duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	var modified_damage = storm_damage * player.damage_coefficient + player.damage_increase
	var modified_radius = storm_radius * player.spell_size_coefficient + player.spell_size_increase
	storm.global_scale = (Vector2(0.01, 0.01) * modified_radius)
	
	storm.visible = true
	storm.get_node('SFX').play()
	
	for i in range(int(modified_duration * 4)):
		for enemy in await Enemies.get_neighbors(global_position, modified_radius):
			enemy.take_damage(modified_damage)
		await get_tree().create_timer(0.25, false).timeout
	
	storm.get_node('SFX').stop()
	storm.visible = false
	
func electrostatic_pulse_ability():
	var nearest_enemy: EnemyBased = await Enemies.get_nearest(global_position, 1500)
	if nearest_enemy != null:
		var electrostatic_pulse = electrostatic_pulse_scene.instantiate()
		electrostatic_pulse.position = nearest_enemy.global_position
		electrostatic_pulse.rotation = global_rotation
		await get_tree().create_timer(1, false).timeout
		add_child(electrostatic_pulse)

func apply_tesla_strike(target: Node):
	print("Applying Tesla Strike to target:", target.name)
	target.take_damage(tesla_damage * player.damage_coefficient + player.damage_increase)
	# Применить дополнительные эффекты при необходимости

func polar_inversion():
	print("Polar Inversion")
	# Временно увеличить вампиризм 

func generate_discharges():
	print("Generating Discharges")
	var enemies = Enemies.get_all_enemies() # Получить всех врагов на уровне
	for enemy in enemies:
		enemy.take_damage(rng.randf_range(discharge_damage_min, discharge_damage_max) * player.damage_coefficient + player.damage_increase)
	# Логика генерации случайных разрядов и нанесения дополнительного урона врагам

func apply_short_circuit():
	print("Applying Short Circuit to enemies with electronic devices or in metal armor")
	var enemies = Enemies.get_enemies_with_electronic_devices_or_metal_armor()
	for enemy in enemies:
		enemy.apply_debuff("Short Circuit", 5.0) # Применить дебафф "Short Circuit" на 5 секунд
	# Логика применения короткого замыкания ко всем врагам с электронными устройствами или в металлических доспехах
