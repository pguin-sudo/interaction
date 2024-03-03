## strong interaction
class_name ForceFieldAbility
extends Ability

## Libs
var rng = RandomNumberGenerator.new()

var duration: float = 5.0
var defense_boost: float = 20.0
var extra_fields: int = 0 # Для Кварковой Стабилизации
var speed_boost: float = 0.0 # Для Гиперсвязи
var health_regeneration_boost: float = 0.0 # Также для Гиперсвязи
var damage_on_activation: float = 0.0 # Для Синглетного Сжатия
var radius: float = 200.0 # Также для Синглетного Сжатия
var enhanced_duration: float = 0.0 # Для Усиленной Прочности
var enhanced_defense: float = 0.0 # Также для Усиленной Прочности
var adaptive_reduction: float = 0.0 # Для Адаптивного Поля


@onready var player = $"../.."

@onready var field_effect = $AnimatedSprite2D

func _ready():
	cooldown = 10.0
	start_cooldown()
	field_effect.set_visible(false)
	
func activate():
	print("Activating ForceFieldAbility")
	player.protection_increase += defense_boost + enhanced_defense
	if speed_boost > 0 or health_regeneration_boost > 0:
		player.speed_increase += speed_boost
		player.regeneration_increase += health_regeneration_boost
	
	var modified_duration = (duration + enhanced_duration) * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	get_tree().create_timer(modified_duration).timeout.connect(_on_force_field_timeout)
	field_effect.set_visible(true)
	
	for i in range(int(modified_duration * 2)):
		apply_damage_to_enemies_in_radius()
		await get_tree().create_timer(0.5).timeout

func apply_damage_to_enemies_in_radius():
	var detection_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = radius * player.spell_size_coefficient + player.spell_size_increase
	detection_area.add_child(collision_shape)
	add_child(detection_area)

	await get_tree().create_timer(0.1).timeout
	
	var enemies = detection_area.get_overlapping_bodies()
	var damage = damage_on_activation * player.damage_coefficient + player.damage_increase
	for enemy in enemies:
		if enemy.has_method("enemy"):
			if rng.randf_range(0, 1) < player.INITIAL_CRITICAL_HIT_CHANCE * player.critical_hit_chance_coefficient + player.critical_hit_chance_increase:
				damage = damage * player.INITIAL_CRITICAL_STRIKE_POWER * player.critical_strike_power_coefficient + player.critical_strike_power_increase
				enemy.take_damage(damage, true)
				continue
			enemy.take_damage(damage, false)
	
	detection_area.queue_free()
	
func _on_force_field_timeout():
	player.protection_increase -= defense_boost + enhanced_defense
	if speed_boost > 0 or health_regeneration_boost > 0:
		player.speed_increase -= speed_boost
		player.regeneration_increase -= health_regeneration_boost
	print("ForceFieldAbility ended")
	field_effect.set_visible(false)

	
# TODO Доделать методы улучшений
func upgrade_quark_stabilization():
	extra_fields += 1
func upgrade_hyperconnection():
	speed_boost = 50.0
	health_regeneration_boost = 2.0
func upgrade_singlet_compression():
	damage_on_activation = 3.0 
func upgrade_enhanced_durability():
	enhanced_duration = 3.0
	enhanced_defense = 10.0
func upgrade_adaptive_field():
	adaptive_reduction = 0.25
