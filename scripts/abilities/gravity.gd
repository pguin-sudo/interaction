extends Ability
class_name Gravity

var duration: float = 5.0
var anomaly_radius: float = 100.0
var anomaly_damage: float = 10.0
var cosmic_link_range: float = 200.0
var cosmic_link_damage: float = 20.0
var gravity_well_radius: float = 150.0
var gravity_well_delay: float = 2.0
var gravity_well_damage: float = 50.0
var gravity_jump_distance: float = 1.0
var black_hole_radius: float = 500.0
var black_hole_damage: float = 1.0

@onready var anomaly_effect = $AnomalyParticles2D
@onready var black_hole_scene = "res://scenes/magic/black_hole.tscn"

func _ready():
	cooldown = 10.0
	ui._on_gravity_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func activate():
	var modified_duration = duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	
	if upgrades[0]: gravity_anomaly(modified_duration)
	if upgrades[1]: satellites()
	if upgrades[2]: gravity_of_fate()
	if upgrades[3]: gravity_jump()
	if upgrades[4]: black_hole(modified_duration)
	
	await get_tree().create_timer(modified_duration, false).timeout
	ui._on_gravity_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func gravity_anomaly(modified_duration):
	anomaly_effect.set_emitting(true)
	
	var modified_radius = anomaly_radius * player.spell_size_coefficient + player.spell_size_increase
	var modified_damage = anomaly_damage * player.damage_coefficient + player.damage_increase
	
	await get_tree().create_timer(modified_duration, false).timeout
	
	anomaly_effect.set_emitting(false)
	
	for enemy in await Enemies.get_neighbors(player.global_position, modified_radius):
		enemy.take_damage(modified_damage)
		enemy.knockback(player.global_position, -300.0)

func satellites():
	pass

func gravity_of_fate():
	pass

func gravity_jump():
	var modified_distance = gravity_jump_distance * player.spell_size_coefficient + player.spell_size_increase
	var target_position = player.position + player.velocity * modified_distance
	player.global_position = target_position
	await get_tree().create_timer(0.1, false).timeout

func black_hole(modified_duration):
	var black_hole_instance = load(black_hole_scene).instantiate()
	var modified_radius = black_hole_radius * player.spell_size_coefficient + player.spell_size_increase
	var modified_damage = black_hole_damage * player.damage_coefficient + player.damage_increase
	black_hole_instance.start(global_position, modified_radius, modified_duration, modified_damage)
	player.get_parent().add_child(black_hole_instance)

