extends RigidBody2D


onready var sprite = $Sprite
onready var life_timer = $LifeTimer
onready var blood = $BloodEffect


func _ready():
	life_timer.start()
	# blood.emit()


func _on_LifeTimer_timeout():
	queue_free()


func flip_sprite():
	sprite.flip_v = true
