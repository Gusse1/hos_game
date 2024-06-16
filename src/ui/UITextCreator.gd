extends Node

# Variables to specify the text, shake duration, and disappearance time
@export var text_ui: Control
@export var display_text: Array[String]
@export var disappear_after: float = 3.0
@export var shake_amount : float
@export var num_to_create = 3
@export var label_theme : Theme

@export var word_salad_json: JSON

var label: Label
var entered: bool

var labels: Array[Label]
var time: float
var start_time: float

func _create_word_salad():
	if is_instance_valid(word_salad_json):
		for num in num_to_create:
			# Create and configure the label
			label = Label.new()
			
			label.text = word_salad_json.data.pick_random()
			label.theme = label_theme
			add_child(label)
			
			# Randomly position the label on the screen
			var screen_size = text_ui.size
			
			var rand_x = randi_range(200, screen_size.x - label.size.x - 200)
			var rand_y = randi_range(200, screen_size.y - label.size.y - 200)
			label.position = Vector2(rand_x, rand_y)
			labels.append(label)
			print_debug("Printed text to screen with rand_x: " + str(rand_x) + " and rand_y: " + str(rand_y))
			
	start_time = time
	

func _create_custom_text():
	for text in display_text:
		# Create and configure the label
		label = Label.new()
		label.text = text
		label.theme = label_theme
		add_child(label)
		
		# Randomly position the label on the screen
		var screen_size = text_ui.size
		
		var rand_x = randi_range(200, screen_size.x - label.size.x - 200)
		var rand_y = randi_range(200, screen_size.y - label.size.y - 200)
		label.position = Vector2(rand_x, rand_y)
		labels.append(label)
		print_debug("Printed text to screen with rand_x: " + str(rand_x) + " and rand_y: " + str(rand_y))

	print_debug("starting timer")
	start_time = time


func _process(delta):
	for l in labels:
		if is_instance_valid(l):
			l.position += Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
			
			if time - start_time >= disappear_after:
				print_debug("ready to remove")
				l.queue_free()
			
	time+=delta

func _on_area_entered(area):
	print_debug("area named entered text area: ", area.name)
	if area.name == "PlayerArea" and not entered:
		entered = true
		_create_custom_text()


func _on_checkpoint_area_area_entered(area):
	print_debug("area named entered text area: ", area.name)
	if area.name == "PlayerArea" and not entered:
		entered = true
		_create_word_salad()
