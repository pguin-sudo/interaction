extends Ability
class_name Electromagnetism

# Libs
var rng = RandomNumberGenerator.new()

var storm_radius: float = 200.0
var storm_damage: float = 30.0
var storm_duration: float = 5.0

var discharge_damage_min: float = 10.0
var discharge_damage_max: float = 20.0

var tesla_damage: float = 100.0

var static_impulse_damage: float = 5.0

@onready var magnetic_storm = "res://scenes/magic/magnetic_storm.tscn"

func _ready():
	cooldown = 8.0
	ui._on_electromagnetism_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func activate():
	print("Активация Электромагнетизма")
	
	var modified_duration = storm_duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	var modified_damage = storm_damage * player.damage_coefficient + player.damage_increase
	
	var magnetic_storm_scene = load(magnetic_storm).instantiate()
	magnetic_storm_scene.start(global_position, storm_radius * player.spell_size_coefficient + player.spell_size_increase, modified_duration, modified_damage)
	player.get_parent().add_child(magnetic_storm_scene)
	
	for enemy in await Enemies.get_neighbors(global_position, storm_radius):
		enemy.take_damage(modified_damage)
		# Apply additional effects if needed
		
	await get_tree().create_timer(modified_duration).timeout
	ui._on_electromagnetism_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func apply_static_impulse(target: Node):
	print("Applying Static Impulse to target:", target.name)
	target.take_damage(static_impulse_damage * player.damage_coefficient + player.damage_increase)
	# Дополнительные эффекты, если необходимо

func apply_tesla_strike(target: Node):
	print("Applying Tesla Strike to target:", target.name)
	target.take_damage(tesla_damage * player.damage_coefficient + player.damage_increase)
	# Дополнительные эффекты, если необходимо

func polar_inversion():
	print("Polar Inversion")
	# Временное увеличение вампиризма 

func generate_discharges():
	print("Generating Discharges")
	var enemies = Enemies.get_all_enemies() # Получаем всех врагов на уровне
	for enemy in enemies:
		enemy.take_damage(rng.randf_range(discharge_damage_min, discharge_damage_max) * player.damage_coefficient + player.damage_increase)
	# Логика генерации случайных разрядов и нанесения дополнительного урона врагам

func apply_short_circuit():
	print("Applying Short Circuit to enemies with electronic devices or in metal armor")
	var enemies = Enemies.get_enemies_with_electronic_devices_or_metal_armor()
	for enemy in enemies:
		enemy.apply_debuff("Short Circuit", 5.0) # Применяем дебафф "Short Circuit" на 5 секунд
	# Логика применения короткого замыкания ко всем врагам с электронными устройствами или в металлических доспехах
