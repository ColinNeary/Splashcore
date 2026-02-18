extends Node3D
class_name Gibblets

## Detach self from current parent so full potion can be destroyed
func spawn_self(spawn_velocity: Vector3, spawn_torque: Vector3) -> void:
	self.call_deferred("reparent", get_tree().current_scene)
	self.process_mode = Node.PROCESS_MODE_INHERIT
	self.visible = true
	_add_velocity_to_gibblets(spawn_velocity, spawn_torque)

func _add_velocity_to_gibblets(velocity: Vector3, torque: Vector3) -> void:
	var child_count : int = self.get_child_count() - 1
	
	if child_count < 0:
		push_error("Number of gibblets is < 1. This will result in a division of 0")
		return
	
	for child in self.get_children():
		if child is RigidBody3D:
			child.linear_velocity = velocity
			child.angular_velocity = torque / child_count

func _on_lifetime_timer_timeout() -> void:
	self.queue_free()
