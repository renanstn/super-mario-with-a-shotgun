extends CharacterBody2D

const SPEED = 50.0
const DEATH_KNOCKBACK = 150.0
const DEATH_JUMP = -200.0
const DEATH_FRICTION = 500.0
const DEATH_ROTATION_SPEED = 180.0
var direction := -1
var sprite_flipped := true
var alive := true
var target_rotation := 0.0

func _physics_process(delta: float) -> void:
	if alive:
		velocity.x = direction * SPEED
		move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		$AnimationPlayer.play("walking")
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
			if rotation_degrees < target_rotation:
				rotation_degrees = min(rotation_degrees + DEATH_ROTATION_SPEED * delta, target_rotation)
		else:
			velocity.x = move_toward(velocity.x, 0, DEATH_FRICTION * delta)
		move_and_slide()


func get_hit():
	if not alive:
		return
	alive = false
	self.set_collision_mask_value(1, false)
	$BloodSplatter.emit()
	$AnimationPlayer.play("dying")
	target_rotation = 90
	velocity.x = -direction * DEATH_KNOCKBACK
	velocity.y = DEATH_JUMP
