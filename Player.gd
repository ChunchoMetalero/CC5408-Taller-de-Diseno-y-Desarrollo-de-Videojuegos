extends CharacterBody2D

var speed = 250
var gravity = 400
var jump_speed = 250
var aceleration = 10000

#REFERENCIAS

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivote: Node2D = $Pivote

func _ready() -> void:
	animation_tree.active = true
	
	
#MOVIMIENTO

func _physics_process(delta):
	#Movimiento del personaje
	var move_input = Input.get_axis("left","right")
	var sign_Move_input = sign(move_input)
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
	
	velocity.x = move_toward(velocity.x,speed * move_input, aceleration * delta)
	
	move_and_slide()
	
	"""
	#Pruebas del Raycast
	var space_state = get_world_2d().direct_space_state
	var x_rayo1 = global_position.x + (200*sign_Move_input)
	var y_rayo1 = global_position.y + 4
	var query = PhysicsRayQueryParameters2D.create(global_position,Vector2(x_rayo1,y_rayo1))
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result:
		print("Hit at point: ", result.position)
	"""
	
	
	
	#ANIMACIONES	
	if move_input != 0:
		pivote.scale.x = sign_Move_input
		
	if Input.is_action_pressed("light"):
		playback.travel("light")
	else:
		playback.travel("idle")
		
		

