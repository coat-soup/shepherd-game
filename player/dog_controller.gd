extends Node

@export var max_distance := 300
@export var dog : Dog
@export var cam : Camera3D
@onready var player: PlayerMovement = $".."
@onready var marker: Node3D = $Marker

var valid_marker := false
var marker_position := Vector3.ZERO

var holding_marker := false

func _ready() -> void:
	dog = get_tree().get_first_node_in_group("dog")
	if dog == null:
		push_warning("No dog found!")
	else:
		dog.nav_agent.target_reached.connect(hide_marker)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("command_dog"):
		holding_marker = true
		marker.visible = true
	if Input.is_action_just_released("command_dog"):
		holding_marker = false
		dog.update_target_position(marker_position)


func _process(delta: float) -> void:
		if holding_marker:
			raycast_marker()


func raycast_marker():
	var space_state = player.get_world_3d().direct_space_state

	var origin = cam.global_position
	var end = origin + -cam.global_basis.z * max_distance
	var query = PhysicsRayQueryParameters3D.create(origin, end, 1)
	query.exclude = [player]

	var result := space_state.intersect_ray(query)
	if result:
		marker_position = result.position
		marker.position = marker_position


func hide_marker():
	marker.visible = false
