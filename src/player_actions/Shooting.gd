class_name shooting extends Node

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

var can_shoot = true
@export var raycast : RayCast3D
@export var firerate : Timer

# Effects
var bullet_impact = preload("res://assets/effects/bulletImpact.tscn")
var bullet_impacts = []

var muzzle_flash = preload("res://assets/effects/muzzle_flash.tscn")
var screen_shake_activation_timer : float = 1
var post_process_config : PostProcessingConfiguration
@export var gunshot_audio_player : AudioStreamPlayer3D
@export var reload_audio_player : AudioStreamPlayer3D
@export var reloaded_audio_player : AudioStreamPlayer3D

# Reload variables
@export var reload_accumulation : float # Speed of reload
var reload_float : float
@export var maganize_size : int
var current_magazine_size : int 
var reloading : bool

# UI Variables
@onready var ammo_display : RichTextLabel = $AmmoText
@export var gun_model : Node3D
@export var crosshair : Line2D
@export var text_creator : Node


# Called when the node enters the scene tree for the first time.
func _ready():
	ammo_display = get_parent().get_node('handgun').AmmoText
	ammo_display.text = str(current_magazine_size)
	post_process_config = shared_variables.post_process_layer.configuration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if screen_shake_activation_timer < 0.1:
		screen_shake_activation_timer += delta
	else:
		post_process_config.ScreenShake = false
	
	if Input.is_action_pressed("shoot") and can_shoot and not reloading and (current_magazine_size > 0):
		gun_model.get_node("AnimationPlayer").stop()
		gun_model.get_node("AnimationPlayer").play("shoot")
		
		firerate.start()
		can_shoot = false
		current_magazine_size-=1
		_shoot()
		ammo_display.text = str(current_magazine_size)
	else:
		if not gun_model.get_node("AnimationPlayer").is_playing():
			gun_model.get_node("AnimationPlayer").play("idle")
	# Weapon is reloaded by holding down the reload key where singular bullets are transmitted to the magazine
	if Input.is_action_pressed("reload") and shared_variables.player_state.current_blood > 0:
		if current_magazine_size < maganize_size:
			if not reload_audio_player.playing:
				reload_audio_player.play()
			reloading = true
			reload_float += reload_accumulation*delta
			shared_variables.player_state._adjust_blood(-(reload_accumulation*delta))
		if reload_float >= 1:
			_reload_singular_bullet()
			reload_float = 0
	if Input.is_action_just_released("reload"):
		reload_audio_player.stop()
		reloading = false
		reload_float = 0


func _shoot():
	_shooting_effects()
	
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		var normal = raycast.get_collision_normal()
		var target = raycast.get_collider()
		
		if target != null:
			_bullet_impact(collision_point)
				
			var enemy_resources = target.get_node("EnemyResources")
			var door_eye = target.name
		
			if enemy_resources != null:
				enemy_resources._damage(shared_variables.player_state.playerVariables.BASE_DAMAGE)
			if door_eye == "eye_collider":
				target._shot_eye()


func _bullet_impact(collision_point: Vector3):
	var local_bullet_impact = bullet_impact.instantiate()
	self.get_tree().current_scene.add_child(local_bullet_impact)
	local_bullet_impact.global_position = collision_point
	local_bullet_impact.look_at(shared_variables.player_body.global_transform.origin, Vector3.UP)
	local_bullet_impact.get_node("Particles").emitting = true
	bullet_impacts.append(local_bullet_impact)
	
	if bullet_impacts.size() > 10:
		bullet_impacts[0].queue_free()
		bullet_impacts.remove_at(0)
	

func _shooting_effects():
	# Muzzle flash
	var local_muzzle_flash = muzzle_flash.instantiate()
	self.get_tree().current_scene.add_child(local_muzzle_flash)
	local_muzzle_flash.global_position = gun_model.gun_tip_position.global_position
	local_muzzle_flash.look_at(shared_variables.player_body.global_transform.origin, Vector3.UP)
	local_muzzle_flash.get_node("Particles").emitting = true
	
	# Screen shake
	post_process_config.ScreenShake = true
	screen_shake_activation_timer = 0
	
	# Gunshot audio
	gunshot_audio_player.stop()
	gunshot_audio_player.global_position = gun_model.gun_tip_position.global_position
	gunshot_audio_player.play()
	
func _on_firerate_timeout():
	can_shoot = true


func _reload_singular_bullet():
	reloaded_audio_player.stop()
	reloaded_audio_player.play()
	if current_magazine_size < maganize_size:
		current_magazine_size += 1
		
		if current_magazine_size > maganize_size:
			current_magazine_size = maganize_size
			
		ammo_display.text = str(current_magazine_size)
