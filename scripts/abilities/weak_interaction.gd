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
	print("Активация Слабого взаимодействия")
	var modified_duration = duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase

	await get_tree().create_timer(modified_duration).timeout
	ui._on_weak_interaction_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func chaos_radiation():
	print("Излучение Хаоса с усилением: ", chaos_radiation_strength)
	# Логика излучения хаоса

func nuclear_decay():
	print("Ядерный Распад с уроном: ", nuclear_decay_damage, " в радиусе ", decay_radius)
	# Логика ядерного распада

func chaotic_pulse():
	print("Хаотический Импульс снижает сопротивление к магии на ", magic_resistance_reduction*100, "% и увеличивает урон союзников на ", ally_damage_boost*100, "%")
	# Логика хаотического импульса

func atomic_strike():
	print("Атомный Удар с уроном ", radiation_strike_damage, " и временным ослаблением защиты")
	# Логика атомного удара

func energy_explosion():
	print("Энергетический Взрыв наносит урон ", energy_explosion_damage, " в радиусе ", energy_explosion_radius, " и ослабляет защиту")
	# Логика энергетического взрыва
