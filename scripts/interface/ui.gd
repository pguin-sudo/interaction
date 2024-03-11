extends CanvasLayer
class_name UI

@onready var score_label = %Score

## Reload Progress
@onready var electromagnetism: TextureProgressBar = $Control/MarginContainer/VBoxContainer/HBoxContainer/ElectromagnetismBar
@onready var gravity: TextureProgressBar = $Control/MarginContainer/VBoxContainer/HBoxContainer/GravityBar
@onready var strong_interaction: TextureProgressBar = $Control/MarginContainer/VBoxContainer/HBoxContainer/StrongInteractionBar
@onready var weak_interaction: TextureProgressBar = $Control/MarginContainer/VBoxContainer/HBoxContainer/WeakInteractionBar
	
func update_score_label(score):
	score_label.text = str(score)
	
func _on_electromagnetism_used(cooldown):
	var steps = 50 * cooldown
	electromagnetism.max_value = steps
	var cooldown_part = cooldown / steps
	for i in range(steps):
		electromagnetism.value = i + 1
		await get_tree().create_timer(cooldown_part).timeout
		
func _on_gravity_used(cooldown):
	var steps = 50 * cooldown
	gravity.max_value = steps
	var cooldown_part = cooldown / steps
	for i in range(steps):
		gravity.value = i + 1  
		await get_tree().create_timer(cooldown_part).timeout
		
func _on_strong_interaction_used(cooldown):
	var steps = 50 * cooldown
	strong_interaction.max_value = steps
	var cooldown_part = cooldown / steps
	for i in range(steps):
		strong_interaction.value = i + 1
		await get_tree().create_timer(cooldown_part).timeout
		
func _on_weak_interaction_used(cooldown):
	var steps = 50 * cooldown
	weak_interaction.max_value = steps
	var cooldown_part = cooldown / steps
	for i in range(steps):
		weak_interaction.value = i + 1
		await get_tree().create_timer(cooldown_part).timeout
