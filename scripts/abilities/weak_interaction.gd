class_name WeakInteractionAbility
extends Ability

## Libs
var rng = RandomNumberGenerator.new()

var damage_on_activation: float = 0.0
var duration: float = 5.0
var weaken_amount: float = 0.2 
var slow_amount: float = 0.5 
var decay_radius: float = 150.0
var toxic_damage: float = 1.0
var mutation_chance: float = 0.3 

@onready var player: Player = $"../.."
@onready var decay_effect = $AnimatedSprite2D

func _ready():
	cooldown = 15.0
	start_cooldown()
	decay_effect.set_visible(false)

func activate():
	print('!!!', global_position)
	print("Activating WeakInteractionAbility")
	var modified_duration = duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	get_tree().create_timer(modified_duration).timeout.connect(_on_decay_timeout)
	decay_effect.set_visible(true)
	
	for i in range(int(modified_duration * 2)):
		apply_decay_to_enemies_in_radius()
		await get_tree().create_timer(0.5).timeout

func apply_decay_to_enemies_in_radius():
	if damage_on_activation > 0:
		var enemies = await Enemies.get_neighbors(global_position, decay_radius * player.spell_size_coefficient + player.spell_size_increase)
		var damage = damage_on_activation * player.damage_coefficient + player.damage_increase
		for enemy in enemies:
			if rng.randf_range(0, 1) < mutation_chance:
				enemy.apply_slow(0, duration)
			enemy.apply_weakness(weaken_amount, duration)
			enemy.apply_slow(slow_amount, duration)
			if rng.randf_range(0, 1) < player.INITIAL_CRITICAL_HIT_CHANCE * player.critical_hit_chance_coefficient + player.critical_hit_chance_increase:
				damage = damage * player.INITIAL_CRITICAL_STRIKE_POWER * player.critical_strike_power_coefficient + player.critical_strike_power_increase
				enemy.take_damage(damage, true)
				continue
			enemy.take_damage(damage, false)

func _on_decay_timeout():
	print("WeakInteractionAbility ended")
	decay_effect.set_visible(false)

# Улучшение: Мутационный Распад
func upgrade_mutational_decay():
	mutation_chance = 0.5

# Улучшение: Бета-Распад
func upgrade_beta_decay():
	decay_radius *= 1.5
	duration += 2.0

# Улучшение: Радиоактивный Вихрь
func upgrade_radioactive_whirl():
	# Добавляем логику для создания мобильной зоны заражения, следующей за врагом.
	# Добавление ссылки на целевого врага и перемещение зоны заражения.
	pass

# Улучшение: Распад
func upgrade_decay():
	weaken_amount = 0.3
	toxic_damage += 0.5 

# Улучшение: Замедляющий Распад
func upgrade_slowing_decay():
	slow_amount = 0.7 

# Улучшение: Токсичные Излучения
func upgrade_toxic_radiations():
	toxic_damage += 1.0
