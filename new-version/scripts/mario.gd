extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var looking_up := false
var sprite_flipped := true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("ui_up"):
		looking_up = true
	else:
		looking_up = false

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			sprite_flipped = true
		elif direction < 0:
			sprite_flipped = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_animate()


func _animate():
	$Sprite2D.flip_h = sprite_flipped
	if velocity.x != 0:
		$AnimationPlayer.play("walking")
	elif velocity.x == 0:
		$AnimationPlayer.play("idle")
	# TODO: Different animations: going up and down
	if velocity.y != 0:
		$AnimationPlayer.play("jumping")
	if looking_up:
		$AnimationPlayer.play("look_up")
