class_name Ability
extends Node2D

var cooldown: float = 40.0
var is_ready: bool = true
var upgrades = [false, false, false, false, false]

@onready var player: Player = $"../.."
@onready var ui: UI = $"../../Camera2D/CanvasLayer/UI"

signal ability_used

func _ready():
	start_cooldown()

func start_cooldown():
	get_tree().create_timer(cooldown * player.cooldown_coefficient + player.cooldown_increase, false).timeout.connect(activate)

func activate():
	pass
