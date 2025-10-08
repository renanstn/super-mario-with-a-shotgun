extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@export var weapon: Node2D
@onready var yahoo_sound = preload("res://sounds/yahoo.wav")
@onready var hahaha_sound = preload("res://sounds/hothothot.wav")
@onready var haha_sound = preload("res://sounds/haha.wav")
var looking_up := false
var sprite_flipped := true
var is_jumping := false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_jump()

	if Input.is_action_pressed("ui_up"):
		_look_up()
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
	if is_on_floor():
		is_jumping = false
		if velocity.x != 0:
			$AnimationPlayer.play("walking")
		elif velocity.x == 0:
			$AnimationPlayer.play("idle")
		if looking_up:
			$AnimationPlayer.play("look_up")
	else:
		is_jumping = true
		if velocity.y < 0:
			$AnimationPlayer.play("jumping")
		elif velocity.y > 0:
			$AnimationPlayer.play("falling")

func _jump():
	velocity.y = JUMP_VELOCITY
	$JumpSound.play()

func _look_up():
	looking_up = true

func killed_something():
	var sounds = [yahoo_sound, hahaha_sound, haha_sound]
	$YahooSound.stream = sounds[randi() % sounds.size()]
	await get_tree().create_timer(0.5).timeout
	$YahooSound.play()
