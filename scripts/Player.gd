extends KinematicBody2D

class_name Player


onready var player_sprite: Sprite = get_node("Sprite")
var velocity: Vector2 # Vetor 2D para mover o personagem

# Variaveis de exportação (podemos alterar pelo painel)
export(int) var speed: int 
export(int) var jump_speed:int
export(int) var player_gravity

# Controle de saltos do personagem 10/05/24
var jump_count:int = 0
var landing:bool = false

# 17/5/2024 - Controlando as ações do player
var attacking:bool = false
var defending:bool = false
var crouching:bool = false
var can_track_input:bool = false

# game loop
func _physics_process(delta):
	horizontal_move()
	vertical_move()
	actions_env()
	gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	player_sprite.animate(velocity)

func actions_env()->void:
	attack()
	defense()
	crouch()
	
func attack()-> void:
	var attack_condition:bool = not attacking and not defending and not crouching
	if Input.is_action_just_pressed("ui_attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true
		
func crouch()-> void:
	if Input.is_action_pressed("ui_crouch") and is_on_floor() and not defending:
		crouching = true
		can_track_input = false
		defending = false
	elif not defending:
		crouching = false
		can_track_input = true
		player_sprite.crouch_off = true
		
func defense()->void:
	if Input.is_action_pressed("ui_defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true



		
		

func vertical_move()->void:
	if is_on_floor():
		jump_count = 0
	var jump_condition:bool = can_track_input and not attacking
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and jump_condition:
		jump_count +=1
		velocity.y = jump_speed
		
func gravity(delta:float)->void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
			
func horizontal_move()->void:
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if can_track_input == false or attacking:
		velocity.x = 0
		return
		
	velocity.x = input_direction *speed

# input serve para decidimos qual tecla/mouse/controle usar
