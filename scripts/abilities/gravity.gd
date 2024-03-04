class_name GravityAbility
extends Ability

var duration: float = 5.0
var cosmic_link_range: float = 200.0
var gravity_jump_distance: float = 1.0
var black_hole_radius: float = 50.0
var cosmic_link_vars: float = 1.1
var bh_damage: float = 2.0

@onready var player: Player = $"../.."
@onready var black_hole_scene = "res://scenes/magic/black_hole.tscn"
@onready var gravity_effect = $AnimatedSprite2D

func _ready():
	cooldown = 10.0
	start_cooldown()
	gravity_effect.set_visible(false)

func activate():
	print("Activating GravityManipulationAbility")
	var modified_duration = duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase
	
	gravity_effect.set_visible(true)
	get_tree().create_timer(modified_duration).timeout.connect(_on_gravity_timeout)
	
	cosmic_link(modified_duration)
	gravity_jump()
	create_black_hole(modified_duration)
	anti_gravity(modified_duration)

func cosmic_link(modified_duration):
	print("Activating Cosmic Link")
	player.damage_coefficient *= cosmic_link_vars
	player.protection_coefficient *= cosmic_link_vars
	await get_tree().create_timer(modified_duration).timeout
	player.damage_coefficient /= cosmic_link_vars
	player.protection_coefficient /= cosmic_link_vars

func _on_gravity_timeout():
	print("GravityAbility ended")
	gravity_effect.set_visible(false)
	
func gravity_jump():
	print("Activating Gravity Jump")
	var modified_distance = gravity_jump_distance * player.spell_size_coefficient + player.spell_size_increase
	var target_position = player.position + player.velocity * modified_distance
	player.global_position = target_position

func create_black_hole(modified_duration):
	print("Creating Black Hole")
	var black_hole = load(black_hole_scene).instantiate()
	black_hole.start(global_position, black_hole_radius * player.spell_size_coefficient + player.spell_size_increase, modified_duration, bh_damage * player.damage_coefficient + player.damage_increase)
	player.get_parent().add_child(black_hole)
	
func anti_gravity(modified_duration):
	print("Activating Anti-Gravity")
	pass
	# TODO ДОДЕЛАТЬ
