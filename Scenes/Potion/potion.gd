extends Node3D
class_name Potion

@onready var lifetime_timer: Timer = %"Lifetime Timer"
@onready var gibblets: Node3D = %Gibblets


# Copy this potion then throw it
func throw(dir:Vector3, force:float, torque:Vector3) -> void:
	var clone := _clone_throwable_self()
	
	clone.freeze = false
	clone.apply_central_impulse(Vector3.ONE * force * dir)
	clone.apply_torque_impulse(torque)
	
	clone.lifetime_timer.start()


# Clone self and set some parameters to make throwing possible
func _clone_throwable_self() -> RigidBody3D:
	# Create clone
	var clone : Node3D = self.duplicate()
	get_tree().current_scene.add_child(clone)
	
	# Set important parameters
	clone.global_position = self.global_position
	clone.set_collision_mask_value(1, true) # potion will scan for walls
	clone.set_collision_mask_value(3, true) # potion will scan for enemies
	clone.contact_monitor = true
	clone.max_contacts_reported = 1
	
	return clone


# If airborne for too long
func _on_lifetime_timer_timeout() -> void:
	self.queue_free()


# When potion collides with something, shatter the pie
func _on_body_entered(_body: Node) -> void:
	gibblets.spawn_self(self.linear_velocity, self.angular_velocity)
	self.queue_free()
