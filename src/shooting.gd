class_name shooting extends Node

var can_shoot = true
@export var raycast : RayCast3D
@export var firerate : Timer
var bullet_impact = preload("res://assets/bulletImpact.tscn")
var bullet_impacts = []

# Reload variables
@export var reload_timer : Timer
@export var maganize_size : int
var current_magazine_size : int 
var reloading : bool

# Recoil variables
@export var spread : float

# UI Variables
@export var ammo_display : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	ammo_display.text = str(current_magazine_size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_pressed("shoot") and can_shoot and not reloading and (current_magazine_size > 0):
		_apply_recoil()
		firerate.start()
		can_shoot = false
		current_magazine_size-=1
		_shoot()
		ammo_display.text = str(current_magazine_size)
				
	if Input.is_action_pressed("reload"):
		print_debug("Reloading!")
		reload_timer.start()
		reloading = true
		

func _apply_recoil():
	var random_angle_x = randf_range(-spread,spread)
	var random_angle_y = randf_range(-spread,spread)
	
	raycast.rotation_degrees = Vector3(90 - random_angle_x, random_angle_y, 0)
	print_debug(raycast.rotation_degrees)

func _shoot():
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		var normal = raycast.get_collision_normal()
		var target = raycast.get_collider()
		
		if target != null:
			var local_bullet_impact = bullet_impact.instantiate()
			self.get_tree().current_scene.add_child(local_bullet_impact)
			local_bullet_impact.global_position = collision_point
			bullet_impacts.append(local_bullet_impact)
			
			if bullet_impacts.size() > 10:
				bullet_impacts[0].queue_free()
				bullet_impacts.remove_at(0)


func _reset_recoil():
	raycast.rotation_degrees = Vector3(90, 0, 0)
	print_debug(raycast.rotation_degrees)

func _on_firerate_timeout():
	can_shoot = true
	_reset_recoil()


func _on_reload_timer_timeout():
	current_magazine_size = maganize_size
	print_debug("Reloaded with mag size: ", current_magazine_size)
	reloading = false
	ammo_display.text = str(current_magazine_size)

