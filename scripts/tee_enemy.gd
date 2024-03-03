extends EnemyBased
	
func enemy():
	pass
	
func get_attack_info():
	return null
	
func die():
	pass
	
func register_enemy(id):
	current_id = id
	return self
	
func take_damage(damage, is_critical = false):
	DamageNumbers.display_number(damage, $damage_spawn.global_position, is_critical)
