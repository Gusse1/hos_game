class_name shooting extends Node

var can_shoot = true
@export var raycast : RayCast3D
@export var firerate : Timer
var bullet_impact = preload("res://assets/bulletImpact.tscn")
var bullet_impacts = []

# Reload variables
@export var reload_timer : Timer
@export var reload_accumulation : float # Speed of reload
var reload_float : float
@export var maganize_size : int
var current_magazine_size : int 
var reloading : bool

var spread : float

# UI Variables
@onready var ammo_display : RichTextLabel = $AmmoText
@export var gun_model : Node3D
@export var crosshair : Line2D
	
# Resource variables
@export var playerState : PlayerState
@export var playerBody : GoldGdt_Body

# Called when the node enters the scene tree for the first time.
func _ready():
	ammo_display = get_parent().get_node('handgun').AmmoText
	print_debug(ammo_display)
	ammo_display.text = str(current_magazine_size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Calculate spread each frame (Maybe move this to another script?) RECOIL DISABLED
	#spread = playerState.playerVariables.BASE_SPREAD + (playerBody.velocity.length() * playerState.playerVariables.SPREAD_MOVEMENT_MODIFIER) 
	#crosshair.scale = Vector2.ONE*spread*1.25
	
	if Input.is_action_pressed("shoot") and can_shoot and not reloading and (current_magazine_size > 0):
		gun_model.get_node("AnimationPlayer").stop()
		gun_model.get_node("AnimationPlayer").play("shoot")
		
		#_apply_recoil() # Temporarily disabled as i reconsider the games direction
		firerate.start()
		can_shoot = false
		current_magazine_size-=1
		_shoot()
		ammo_display.text = str(current_magazine_size)
		
	# Weapon is reloaded by holding down the reload key where singular bullets are transmitted to the magazine
	if Input.is_action_pressed("reload") and playerState.current_blood > 0:
		if current_magazine_size < maganize_size:
			reloading = true
			reload_float += reload_accumulation*delta
			playerState._adjust_blood(-(reload_accumulation*delta))
		if reload_float >= 1.5:
			_reload_singular_bullet()
			reload_float = 0
	if Input.is_action_just_released("reload"):
		reloading = false
		reload_float = 0

		

func _apply_recoil():
	spread = playerState.playerVariables.BASE_SPREAD + (playerBody.velocity.length() * playerState.playerVariables.SPREAD_MOVEMENT_MODIFIER) 
		
	var random_angle_x = randf_range(-spread,spread)
	var random_angle_y = randf_range(-spread,spread)
	
	raycast.rotation_degrees = Vector3(90 - random_angle_x, random_angle_y, 0)

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
				
			var enemy_resources = target.get_node("EnemyResources")
			var door_eye = target.get_node("eye")
		
			if enemy_resources != null:
				enemy_resources._damage(playerState.playerVariables.BASE_DAMAGE)
			if door_eye != null:
				door_eye._shot_eye()


func _reset_recoil():
	raycast.rotation_degrees = Vector3(90, 0, 0)

func _on_firerate_timeout():
	can_shoot = true
	_reset_recoil()


func _on_reload_timer_timeout():
	current_magazine_size = maganize_size
	print_debug("Reloaded with mag size: ", current_magazine_size)
	reloading = false
	ammo_display.text = str(current_magazine_size)

func _reload_singular_bullet():
	if current_magazine_size < maganize_size:
		current_magazine_size += 1
		ammo_display.text = str(current_magazine_size)
