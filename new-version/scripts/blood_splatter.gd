extends CPUParticles2D

func emit():
	emitting = true
	var tween = create_tween()
	tween.tween_property(self, "initial_velocity_max", 30.0, 3.0)
	tween.tween_callback(Callable(self, "_stop"))

func _stop():
	emitting = false
