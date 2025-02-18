extends CharacterBody3D

class_name Dog

@export var nav_agent: NavigationAgent3D

@export var speed := 6.0

func _physics_process(delta: float) -> void:
	var cur_pos = global_position
	var next_pos = nav_agent.get_next_path_position()
	var vel = (next_pos - cur_pos).normalized() * speed
	
	velocity = vel
	move_and_slide()

func update_target_position(t_pos):
	nav_agent.set_target_position(t_pos)
