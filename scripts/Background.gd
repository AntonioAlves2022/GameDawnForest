extends ParallaxBackground
class_name Background

# Variável que pode ser alterada 
# na interface da Godot
export(bool) var can_process
export(Array, int) var layer_speed

# Função ou código que é executada
# logo que esta cena é carregada no jogo
func ready():
	print("Game is starting")
	if can_process == false:
		set_physics_process(false)

func _physics_process(delta):
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			get_child(index).motion_offset.x -= delta*layer_speed[index]
			
