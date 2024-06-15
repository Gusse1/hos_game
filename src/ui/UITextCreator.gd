extends Node

# Variables to specify the text, shake duration, and disappearance time
@export var text_ui: Control
@export var display_text: String
@export var disappear_after: float = 3.0
@export var shake_amount : float
@export var num_to_create = 3
@export var label_theme : Theme

var label: Label
var entered: bool
func _create_text():
	for num in num_to_create:
		# Create and configure the label
		label = Label.new()
		label.text = display_text
		label.theme = label_theme
		add_child(label)
		
		# Randomly position the label on the screen
		var screen_size = text_ui.size
		
		var rand_x = randi_range(200, screen_size.x - label.size.x - 200)
		var rand_y = randi_range(200, screen_size.y - label.size.y - 200)
		label.position = Vector2(rand_x, rand_y)
		
		print_debug("Printed text to screen with rand_x: " + str(rand_x) + " and rand_y: " + str(rand_y))

		# Schedule the disappearance
		await get_tree().create_timer(disappear_after).timeout
		label.queue_free()

func _process(delta):
	if is_instance_valid(label):
		label.position += Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))

func _on_area_entered(area):
	print_debug("area named entered text area: ", area.name)
	if area.name == "PlayerArea" and not entered:
		entered = true
		_create_text()
