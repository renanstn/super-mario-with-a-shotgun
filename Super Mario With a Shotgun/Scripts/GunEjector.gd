extends Position2D


export var cartridge_scene : PackedScene
export var player_node_path : NodePath

var player : Node
var parent_node : Node


func _ready():
	player = get_node(player_node_path)


func eject():
	var cartridge = cartridge_scene.instance()
	var looking_to_right = -1 if player.looking_to_right else 1
	cartridge.global_position = self.global_position
	cartridge.rotation = self.global_rotation * looking_to_right
	cartridge.apply_impulse(Vector2(0,0), Vector2(20 * looking_to_right, -50))
	cartridge.add_torque(30 * looking_to_right)
	player.get_parent().add_child(cartridge)
