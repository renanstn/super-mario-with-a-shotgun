extends CharacterBody2D

const SPEED = 50.0
var direction := -1
var sprite_flipped := true

func _physics_process(delta: float) -> void:
	velocity.x = direction * SPEED
	move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func get_hit():
	print("ai meu cusin!!!!")
