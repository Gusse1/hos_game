extends Node3D

@export var fast_noise : FastNoiseLite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_height_warper()
	
func _height_warper():
	fast_noise.seed += randf_range(0,10000)
