extends CharacterBody3D

class_name Sheep

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@export var speed := 1.0
@export var turn_speed := 1.0

@export var scared_distance := 5.0
@export var follow_distance := 5.0

@export var centering_factor := 0.2

@export var scared_of : Array[Node3D]

var walk_dir := Vector3()

var sheep : Array[Sheep]

func _ready():
	for s in get_tree().get_nodes_in_group("sheep"):
		if s != self:
			sheep.append(s as Sheep)

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	follow_other_sheep()
	move_away_from_danger()
	
	walk_dir = walk_dir.normalized()
	
	var d_rotation = walk_dir.signed_angle_to(transform.basis.z, Vector3.UP)
	if abs(rad_to_deg(d_rotation)) > 5:
		rotate(Vector3.UP, -d_rotation * turn_speed * delta)
		
	var input_dir := Vector3(0,1,0)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#direction = Vector3(walk_dir.x, 0, walk_dir.z).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 10)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 10)
		
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2)

	move_and_slide()


func move_away_from_danger():
	var avg_dir := Vector3.ZERO
	for x in scared_of:
		var diff := global_position - x.global_position
		if diff.length() <= scared_distance:
			avg_dir += diff
		
	walk_dir += avg_dir.normalized()
	
func follow_other_sheep():
	var avg_dir := Vector3.ZERO
	var center := Vector3.ZERO
	var n_seen = 0
	for s in sheep:
		var in_range := s.global_position.distance_to(global_position) <= follow_distance
		var in_sight_cone := rad_to_deg(global_basis.z.angle_to(s.global_position - global_position)) <= 30
		if in_range and in_sight_cone:
			avg_dir += s.global_basis.z
			center += s.global_position
			n_seen += 1
	
	avg_dir = avg_dir.normalized()	
	walk_dir += avg_dir
	
	if n_seen > 0:
		center /= n_seen
		walk_dir += (center - global_position).normalized() * centering_factor
	
	walk_dir = walk_dir.normalized()
