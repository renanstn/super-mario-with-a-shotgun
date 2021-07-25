extends KinematicBody2D


const UP: Vector2 = Vector2(0, -1)
const GRAVITY: int = 15
const JUMP: int = 350

onready var sprite = $Sprite
onready var shoot_sprite = $ShootSprite
onready var animator = $AnimationPlayer
onready var animator_shoot = $AnimationPlayerShoot
onready var audio_player_jump = $AudioStreamPlayerJump
onready var audio_player_shoot = $AudioStreamPlayerShoot
onready var audio_player_reload = $AudioStreamReload
onready var shotgun_range = $ShotgunArea
onready var reload_timer = $ReloadingTimer

export var gun_eject_path: NodePath
export var speed: int = 150
var motion: Vector2 = Vector2()
var gun_ejector: Node
var looking_to_right: bool = false
var reloading: bool = false
var bullets : int = 1

signal player_flipped(direction)

func _ready():
	gun_ejector = get_node(gun_eject_path)


func _physics_process(_delta):
	motion.y += GRAVITY
	if Input.is_action_just_pressed("shoot"):
		shoot()
	motion = move_and_slide(fromInputsToMotion(), UP)
	animate()


func fromInputsToMotion() -> Vector2:
	if Input.is_action_pressed("move_right"):
		motion.x = speed
	elif Input.is_action_pressed("move_left"):
		motion.x = -speed
	else:
		motion.x = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		motion.y = -JUMP
		audio_player_jump.play()
	if is_on_floor() and Input.is_action_just_pressed("reload") and not reloading:
		reload()
	return motion


func animate() -> void:
	if motion.x != 0:
		animator.play("Walking")
	else:
		if not reloading:
			animator.play("Idle")
	if !is_on_floor():
		animator.play("Jumping")
	if motion.x > 0 and not looking_to_right:
		looking_to_right = true
		scale.x = -1
		emit_signal("player_flipped", "right")
	if motion.x < 0 and looking_to_right:
		looking_to_right = false
		scale.x = -1
		emit_signal("player_flipped", "left")


func shoot():
	if bullets > 0:
		bullets -= 1
		shoot_sprite.visible = true
		animator_shoot.play("Shoot")
		audio_player_shoot.play()
		var targets = shotgun_range.get_overlapping_bodies()
		for target in targets:
			if "enemy" in target.get_groups():
				target.die()


func reload():
	reload_timer.start()
	audio_player_reload.play()
	reloading = true
	gun_ejector.eject()
	animator.play("Reload")
	if bullets < 1:
		bullets += 1


func _on_AnimationPlayerShoot_animation_finished(anim_name):
	if anim_name == "Shoot":
		shoot_sprite.visible = false


func _on_ReloadingTimer_timeout():
	reloading = false
