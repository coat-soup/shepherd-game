extends Node3D

@export var trigger_area : Area3D
@export var ui : UI

var num_sheep = 0


func _ready() -> void:
	trigger_area.body_entered.connect(on_entered)


func on_entered(body : Node3D):
	body = body as Sheep
	if body:
		print("sheep entered!!!")
		num_sheep += 1
		ui.hud.set_sheep_counter(num_sheep)
		body.disable_and_delete()
