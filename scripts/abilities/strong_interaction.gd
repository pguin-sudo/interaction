extends Ability
class_name StrongInteraction

# Параметры способности
var force_field_strength: float = 1.0  # Пример параметра для демонстрации, его можно изменить в соответствии с механикой игры
var damage: float = 10.0  # Урон от способности
var knockback_distance: float = 100.0  # Дистанция отталкивания
var stun_duration: float = 2.0  # Длительность оглушения
var electromagnetic_storm_duration: float = 3.0  # Длительность электромагнитного шторма
var neutron_explosion_damage: float = 50.0  # Урон от нейтронного взрыва
var explosion_radius: float = 200.0  # Радиус действия взрыва

var duration: float = 3.0

func _ready():
	cooldown = 9.0
	ui._on_strong_interaction_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func activate():
	print("Активация Сильного взаимодействия")
	
	# Здесь должна быть логика активации базовой способности
	
	var modified_duration = duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	
	create_force_field()
	
	await get_tree().create_timer(modified_duration).timeout
	ui._on_strong_interaction_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func create_force_field():
	print("Создание Силового Поля с усилением: ", force_field_strength)
	# Логика создания силового поля

func energy_pulse():
	print("Энергетический Импульс с уроном: ", damage)
	# Логика энергетического импульса

func polar_eruption():
	print("Полярное Извержение с уроном: ", damage, " и оглушением на ", stun_duration, " сек.")
	# Логика полярного извержения

func kinetic_discharge():
	print("Кинетический Разряд с отбрасыванием на ", knockback_distance)
	# Логика кинетического разряда

func electromagnetic_storm():
	print("Электромагнитный Шторм длительностью ", electromagnetic_storm_duration, " сек.")
	# Логика электромагнитного шторма

func neutron_explosion():
	print("Нейтронный Взрыв с уроном ", neutron_explosion_damage, " в радиусе ", explosion_radius)
	# Логика нейтронного взрыва
