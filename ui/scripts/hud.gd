extends Control

class_name HUD

@onready var sheep_counter: Label = $SheepCounter


func set_sheep_counter(sheep):
	sheep_counter.text = str(sheep) + " sheep"
