extends Node3D

@export var light : SpotLight3D
@export var subviewport : SubViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(subviewport.get_texture())
	light.light_projector = subviewport.get_texture()
