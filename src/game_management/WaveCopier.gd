extends Node3D

var copy_wave: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#copy_wave = Node3D.new()
	#copy_wave.name = self.name + "_COPY"
	#self.add_sibling.call_deferred(copy_wave)
	

func _reset_wave():
	for enemy in copy_wave.get_children():
		enemy.queue_free()


func _activate_wave() -> Node3D:
	copy_wave = Node3D.new()
	copy_wave.name = self.name + "_COPY"
	copy_wave.position = self.position
	self.add_sibling.call_deferred(copy_wave)
	
	for enemy in self.get_children():
		print_debug("Adding child")
		var duped_enemy = enemy.duplicate()
		copy_wave.add_child.call_deferred(duped_enemy)
		
		var char_body = enemy.get_node("CharacterBody3D")
		char_body._enable_enemy()
	return copy_wave

