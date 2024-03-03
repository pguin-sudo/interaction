class_name Ability
extends Node2D

var cooldown: float = 1.0
var is_ready: bool = true

func _ready():
	start_cooldown()
		
func use():
	activate()
	start_cooldown()

func start_cooldown():
	get_tree().create_timer(cooldown).timeout.connect(use)

func activate():
	pass 
