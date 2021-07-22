extends Position2D

onready var particles = $CPUParticles2D


func eject():
	particles.emitting = true
