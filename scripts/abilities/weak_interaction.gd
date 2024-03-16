extends Ability
class_name WeakInteraction

# Параметры способности
var chaos_radiation_strength: float = 1.0
var nuclear_decay_damage: float = 20.0  # Урон от ядерного распада
var decay_radius: float = 150.0  # Радиус действия ядерного распада
var armor_weakness_duration: float = 5.0  # Время ослабления брони
var magic_resistance_reduction: float = 0.2  # Снижение сопротивления к магии
var ally_damage_boost: float = 1.2  # Увеличение урона союзниками
var radiation_strike_damage: float = 30.0  # Урон от атомного удара
var energy_explosion_damage: float = 25.0  # Урон от энергетического взрыва
var energy_explosion_radius: float = 100.0  # Радиус действия энергетического взрыва

var duration: float = 2.0

func _ready():
	cooldown = 5.0
	ui._on_weak_interaction_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func activate():
	var modified_duration = duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase

	await get_tree().create_timer(modified_duration, false).timeout
	ui._on_weak_interaction_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func chaos_radiation():
	pass
	# Логика излучения хаоса

func nuclear_decay():
	pass
	# Логика ядерного распада

func chaotic_pulse():
	pass
	# Логика хаотического импульса

func atomic_strike():
	pass
	# Логика атомного удара

func energy_explosion():
	pass
	# Логика энергетического взрыва
