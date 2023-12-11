extends CharacterBody2D

var speed = 250
var gravity = 400
var jump_speed = 250
var aceleration = 10000

var current_pickable: PickLantern = null


#REFERENCIAS
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var collision = $CollisionShape2D
@onready var pivote: Node2D = $Pivote
@onready var pick_new_lantern = $Pivote/Pick_new_Lantern

@onready var pickable_marker = $Pivote/PickableMarker
@onready var pickable_drop_marker = $Pivote/PickableDropMarker



func _ready() -> void:
	animation_tree.active = true
	add_to_group("player")
	
#MOVIMIENTO
	
			
func _physics_process(delta):
	### MOVIMIENTO DEL PERSONAJE ### 
	var move_input = Input.get_axis("left","right")
	var sign_Move_input = sign(move_input)
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		
		
	if Input.is_action_just_pressed("interact"):
		interact()
		
	if Input.is_action_just_pressed("light") and current_pickable:
		current_pickable.encender()
	
	velocity.x = move_toward(velocity.x,speed * move_input, aceleration * delta)
	
	move_and_slide()
	### ANIMACIONES	###
	
	if move_input != 0:
		pivote.scale.x = sign_Move_input
		
	
		



func interact():
	var pickable: PickLantern = pick_new_lantern.get_pickable()
	if current_pickable:
		current_pickable.global_rotation = global_rotation
		current_pickable.drop(get_parent(), pickable_drop_marker.global_position)
		current_pickable = null
	elif pickable:
		current_pickable = pickable
		pickable.global_rotation = global_rotation
		pickable.pick(pivote, pickable_marker.global_position)



