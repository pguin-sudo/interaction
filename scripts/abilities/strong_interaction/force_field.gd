## strong interaction
class_name ForceFieldAbility
extends Ability

var duration: float = 5.0
var defense_boost: float = 20.0

func _ready():
	cooldown = 10.0
	start_cooldown()
		
func activate():
	print('ForceFieldAbility')
	var player = get_parent().get_parent()
	player.protection_increase += defense_boost
	get_tree().create_timer(duration * player.duration_of_spells_coefficient + player.duration_of_spells_increase)
	player.protection_increase -= defense_boost
