extends RigidBody2D


onready var sprite = $Sprite


func _ready():
	$LifeTimer.start()


func _on_LifeTimer_timeout():
	queue_free()


func flip_sprite():
	sprite.flip_v = true
