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
@onready var cosmic_link_effect:  = $CosmicLinkParticleSystem2D
@onready var gravity_well_effect = $GravityWellParticles2D
@onready var gravity_jump_effect = $GravityParticles2D
@onready var black_hole_scene = "res://scenes/magic/black_hole.tscn"

func _ready():
	cooldown = 10.0
	ui._on_gravity_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()
	
	anomaly_effect.set_emitting(false)
	cosmic_link_effect.set_emitting(false)
	gravity_well_effect.set_emitting(false)
	gravity_jump_effect.set_emitting(false)

func activate():
	print("Activating GravityManipulationAbility")
	
	var modified_duration = duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	
	anomaly(modified_duration)
	cosmic_link(modified_duration)
	gravity_well(modified_duration)
	gravity_jump()
	create_black_hole(modified_duration)
	
	await get_tree().create_timer(modified_duration).timeout
	ui._on_gravity_used(cooldown * player.cooldown_coefficient + player.cooldown_increase)
	start_cooldown()

func anomaly(modified_duration):
	print("Creating Gravitational Anomalies")
	anomaly_effect.set_emitting(true)
	
	var modified_radius = anomaly_radius * player.spell_size_coefficient + player.spell_size_increase
	var modified_damage = anomaly_damage * player.damage_coefficient + player.damage_increase
	
	await get_tree().create_timer(modified_duration).timeout
	
	anomaly_effect.set_emitting(false)
	
	for enemy in await Enemies.get_neighbors(player.global_position, modified_radius):
		enemy.take_damage(modified_damage)
		enemy.knockback(player.global_position, -300.0)

func cosmic_link(modified_duration):
	print("Activating Cosmic Link")
	cosmic_link_effect.set_emitting(true)
	
	var modified_range = cosmic_link_range * player.spell_size_coefficient + player.spell_size_increase
	var modified_damage = cosmic_link_damage * player.damage_coefficient + player.damage_increase
	
	await get_tree().create_timer(modified_duration).timeout
	
	cosmic_link_effect.set_emitting(false)
	
	for enemy in await Enemies.get_neighbors(player.global_position, modified_range):
		enemy.take_damage(modified_damage)
		enemy.knockback(player.global_position, -300.0)

func gravity_well(modified_duration):
	print("Activating Gravity Well")
	gravity_well_effect.set_emitting(true)
	
	var modified_radius = gravity_well_radius * player.spell_size_coefficient + player.spell_size_increase
	var modified_damage = gravity_well_damage * player.damage_coefficient + player.damage_increase
	
	await get_tree().create_timer(modified_duration - gravity_well_delay).timeout
	
	for enemy in await Enemies.get_neighbors(global_position, modified_radius):
		enemy.take_damage(modified_damage)
	
	await get_tree().create_timer(gravity_well_delay)
	
	gravity_well_effect.set_emitting(false)

func gravity_jump():
	print("Activating Gravity Jump")
	var modified_distance = gravity_jump_distance * player.spell_size_coefficient + player.spell_size_increase
	var target_position = player.position + player.velocity * modified_distance
	player.global_position = target_position
	gravity_jump_effect.set_emitting(true)
	
	await get_tree().create_timer(0.2)
	
	gravity_jump_effect.set_emitting(false)

func create_black_hole(modified_duration):
	print("Creating Black Hole")
	var black_hole = load(black_hole_scene).instantiate()
	var modified_radius = black_hole_radius * player.spell_size_coefficient + player.spell_size_increase
	var modified_damage = black_hole_damage * player.damage_coefficient + player.damage_increase
	black_hole.start(global_position, modified_radius, modified_duration, modified_damage)
	player.get_parent().add_child(black_hole)

