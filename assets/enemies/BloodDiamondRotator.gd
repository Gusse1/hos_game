extends GPUParticles3D

@export var blood_cloud_ui_text : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_random_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += Vector3(0,delta*1,0)

func _spawn_random_text():
	blood_cloud_ui_text._create_word_salad()
