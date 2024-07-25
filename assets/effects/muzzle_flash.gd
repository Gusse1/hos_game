extends Node3D

func _on_particles_finished():
	queue_free()
