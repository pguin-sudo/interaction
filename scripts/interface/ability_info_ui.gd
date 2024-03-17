extends PanelContainer

@onready var icon: TextureRect = $MarginContainer/TextureRect
@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var description: Label = $MarginContainer/VBoxContainer/Description

func set_info(lable_text: String, description_text: String, icon_texture: Texture2D):
	label.text = lable_text
	description.text = description_text
	icon.texture = icon_texture
