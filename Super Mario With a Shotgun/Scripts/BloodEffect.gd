extends Position2D


signal blood_over
onready var particles = $CPUParticles2D
onready var timer = $Timer


func emit():
	particles.emitting = true
	timer.start()


func _on_Timer_timeout():
	emit_signal("blood_over")
