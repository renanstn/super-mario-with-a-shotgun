extends Node2D


export var blood : PackedScene

func _physics_process(_delta):
	if Input.is_action_just_pressed("mouse_left"):
		for _i in range(55):
			var blood_instance : Area2D = blood.instance()
			blood_instance.global_position = get_global_mouse_position()
			add_child(blood_instance)
