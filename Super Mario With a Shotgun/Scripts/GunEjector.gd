extends Position2D


export var cartridge_scene : PackedScene
export var player_node_path : NodePath

var player : Node
var parent_node : Node


func _ready():
	player = get_node(player_node_path)


func eject():
	print("ejefc")
	var cartridge = cartridge_scene.instance()
	# Variável que auxilia a correção do ângulo caso o
	# braço esteja com a escala invertida
	var looking_to_right = -1 if player.looking_to_right else 1
	cartridge.global_position = self.global_position
	cartridge.rotation = self.global_rotation * looking_to_right
	# Aplicar impulso e rotação na capsula, sempre usando o
	# 'looking_to_right' para corrigir a inversão de scale
	cartridge.apply_impulse(Vector2(0,0), Vector2(20 * looking_to_right, -50))
	cartridge.add_torque(30 * looking_to_right)
	player.get_parent().add_child(cartridge)
