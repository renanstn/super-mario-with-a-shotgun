extends Node2D

@export var parent_node: Node
@export var shotgun_offset: Vector2 = Vector2.ZERO
@onready var hitbox = $ShotgunArea

func _process(_delta: float):
	if not parent_node:
		return

	global_position = parent_node.global_position + shotgun_offset
	var parent_sprite: Sprite2D = parent_node.get_node_or_null("Sprite2D")
	if not parent_sprite:
		return

	scale.x = abs(scale.x) * -1 if parent_sprite.flip_h else abs(scale.x) * 1
	if parent_node.is_jumping:
		$AnimationPlayer.play("shotgun_jumping")
		rotation_degrees = 30 * 1 if parent_sprite.flip_h else 30 * -1
	else:
		$AnimationPlayer.play("shotgun_steady")
		rotation_degrees = 0
	
	if Input.is_action_just_pressed("attack"):
		_shoot()

func _shoot():
	$ShootSound.play()
	$ShootAnimationPlayer.play("shoot")
	var bodies = hitbox.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("get_hit") and body.alive:
			body.get_hit()
			parent_node.killed_something()
