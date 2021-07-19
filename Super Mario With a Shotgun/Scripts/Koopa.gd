extends KinematicBody2D


const UP: Vector2 = Vector2(0, -1)
const GRAVITY: int = 15
enum STATES {
	IDLE,
	WALKING,
	DYING,
}

onready var animator : AnimationPlayer = $AnimationPlayer

export var player_path : NodePath
export var min_distance_from_player: int = 100
export var speed : int = 40
var motion: Vector2 = Vector2(0, 0)
var player : Node
var state = STATES.IDLE
var looking_to_right = false


func _ready():
	player = get_node(player_path)


func _physics_process(_delta):
	motion.y += GRAVITY
	set_motion()
	motion = move_and_slide(motion, UP)
	animate()


func set_motion():
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
	print("DIE")
	pass
