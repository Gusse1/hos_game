extends ItemList


# We need to disable the tooltips for the items in code like this
func _ready():
	for item_num in get_item_count():
		set_item_tooltip_enabled(item_num, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
