extends Control

@onready var credits: Panel = $Credits

var video_done: bool
var credits_waiter: float
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if video_done:
		credits_waiter += delta
		
		if credits_waiter > 10:
			credits.visible = true
		if credits_waiter > 30:
			get_tree().quit()


func _on_cutscene_video_finished():
	video_done = true
