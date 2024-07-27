extends Node3D

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

@export var projectile_speed: float = 10

var move_direction: Vector3
var kill_timer: float

@export var raycast: RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(shared_variables.player_body.global_transform.origin, Vector3.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move the object forward in its local coordinates
	global_position += (move_direction * projectile_speed * delta)
	
	kill_timer += delta
	if kill_timer > 10:
		queue_free()

	# Perform the raycast
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		var normal = raycast.get_collision_normal()
		var collider = raycast.get_collider()
		
		if global_position.distance_to(collision_point) < 1:
			print("Killing")
			queue_free()

