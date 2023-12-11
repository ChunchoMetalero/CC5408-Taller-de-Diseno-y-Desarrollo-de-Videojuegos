extends CharacterBody2D

var speed = 250
var gravity = 400
var jump_speed = 250
var aceleration = 10000

var current_pickable: PickLantern = null

var is_crouching = false

#REFERENCIAS
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivote: Node2D = $Pivote
@onready var area: Area2D = $"../linterna/area"
@onready var tomarlinterna = $"../linterna/area/tomarlinterna"
@onready var collision = $CollisionShanimation_playere2D
@onready var rayo: RayCast2D = $Pivote/Rayo


@onready var pick_new_lantern = $Pivote/Pick_new_Lantern

@onready var pickable_marker = $Pivote/PickableMarker
@onready var pickable_drop_marker = $Pivote/PickableDropMarker

var Idle_cshape = preload("res://Themes/CollisionShapes/Idle.tres")
var Crouch_cshape = preload("res://Themes/CollisionShapes/Crouch.tres")
var CrouchWalk_cshape = preload("res://Themes/CollisionShapes/CrouchWalk.tres")
func _ready() -> void:
	animation_tree.active = true
	add_to_group("player")
	
#MOVIMIENTO
func tomar():
	for body in area.get_overlanimation_playerping_bodies():
		if body.is_in_group("player"):
			return true
	return false


			
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
	
		
	if Input.is_action_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		stand()
	
	velocity.x = move_toward(velocity.x,speed * move_input, aceleration * delta)
	
	move_and_slide()
	update_animations()






	### ANIMACIONES	###

	
	
	if move_input != 0:
		pivote.scale.x = sign_Move_input
		playback.travel("walk")
		
	preload ("res://sprites/Flashlight_wide_range_sprite_sheet.png")
		
func update_animations():
	var move_input = Input.get_axis("left","right")
	if is_on_floor():
		if move_input == 0:
			if is_crouching:
				animation_player.play("crouch")
			else:
				animation_player.play("idle")
		else:
			if is_crouching:
				animation_player.play("crouch_walk")
			else:
				animation_player.play("walk")
	else:
		if is_crouching == false:
			if velocity.y < 0:
				animation_player.play("jump")
			elif velocity.y > 0:
				animation_player.play("fall")
		else:
			if move_input == 0:
				animation_player.play("crouch")
			else:
				animation_player.play("crouch_walk")

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
	
func crouch():
	var move_input = Input.get_axis("left","right")
	if is_crouching:
		return
	is_crouching = true
	if move_input == 0:
		collision_shape_2d.shape = Crouch_cshape
	else:
		collision_shape_2d.shape = CrouchWalk_cshape


func stand():
	if is_crouching == false:
		return
	is_crouching = false
	collision_shape_2d.shape = Idle_cshape
