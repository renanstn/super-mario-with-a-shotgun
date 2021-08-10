extends KinematicBody2D


const UP: Vector2 = Vector2(0, -1)
const GRAVITY: int = 15

enum STATES {
	IDLE,
	WALKING,
	DYING,
}

onready var animator = $AnimationPlayer
onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var ground_checker = $RayCast2D
onready var death_timer = $DeathTimer

export var player_path : NodePath
export var blood_emitter_path : NodePath
export var min_distance_from_player: int = 100
export var speed : int = 40
export var dead_koopa : PackedScene

var motion: Vector2 = Vector2(0, 0)
var player : Node
var blood_emitter : Node
var state = STATES.IDLE
var looking_to_right = false


func _ready():
	player = get_node(player_path)
	blood_emitter = get_node(blood_emitter_path)


func _physics_process(_delta):
	motion.y += GRAVITY
	if state != STATES.DYING and player:
		# follow_player()
		walk()
	motion = move_and_slide(motion, UP)
	animate()


func walk():
	if not ground_checker.is_colliding():
		looking_to_right = !looking_to_right
		scale.x = -1
	if looking_to_right:
		motion.x = speed
	else:
		motion.x = -speed


func follow_player():
	"""
	This function is not being used
	"""
	var distance_from_player = player.position.x - self.position.x
	if abs(distance_from_player) < min_distance_from_player:
		state = STATES.WALKING
		if distance_from_player > 0:
			motion.x = speed
			if not looking_to_right:
				looking_to_right = true
				scale.x = -1
		else:
			motion.x = -speed
			if looking_to_right:
				scale.x = -1
				looking_to_right = false
	else:
		motion.x = 0
		state = STATES.IDLE


func animate():
	if motion.x != 0:
		animator.play("Walking")
	else:
		animator.play("Idle")


func die():
	state = STATES.DYING
	death_timer.start()
	if blood_emitter:
		sprite.visible = false
		collision.disabled = true
		blood_emitter.emit()
	if dead_koopa:
		throw_body()


func throw_body():
	var dead_body = dead_koopa.instance()
	var throw_direction = -1 if player.position.x < self.position.x else 1
	dead_body.global_position = self.global_position
	dead_body.rotation = self.global_rotation * throw_direction
	dead_body.apply_impulse(Vector2(0,0), Vector2(-200 * throw_direction, -50))
	dead_body.add_torque(-500 * throw_direction)
	player.get_parent().add_child(dead_body)
	if looking_to_right:
		dead_body.flip_sprite()


func _on_DeathTimer_timeout():
	queue_free()
