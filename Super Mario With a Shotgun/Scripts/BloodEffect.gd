extends Position2D


onready var particles = $CPUParticles2D


func emit():
	particles.emitting = true
