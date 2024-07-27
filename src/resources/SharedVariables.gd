extends Node

@export_category("Player")
@export var player_node : Node3D
@export var player_body : Node3D
@export var player_state : PlayerState
@export var post_process_layer : CanvasLayer
@export var text_ui : Control

@export_category("Video")
@export var video_screen_player : SubViewport
@export var eye_screen_player : SubViewport
