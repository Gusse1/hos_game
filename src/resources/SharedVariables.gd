extends Node

@export_category("Player")
@export var player_node : Node3D
@export var player_body : Node3D
@export var player_state : PlayerState
@export var post_process_layer : CanvasLayer
@export var text_ui : Control

@export_category("GameLogic")
@export var save_game_manager : Node
@export var settings_panel : Panel

@export_category("Video")
@export var video_screen_player : SubViewport
@export var eye_screen_player : SubViewport

@export_category("Enemies")
var combat_areas : Node

func _ready():
	combat_areas = get_parent().get_node("CombatAreas")
