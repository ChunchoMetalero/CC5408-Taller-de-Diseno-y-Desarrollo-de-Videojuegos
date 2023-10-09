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
@onready var area: Area2D = $"../linterna/area"
@onready var tomarlinterna = $"../linterna/area/tomarlinterna"
@onready var collision = $CollisionShape2D
@onready var rayo: RayCast2D = $Pivote/Rayo

@onready var conlinterna: bool = false

func _ready() -> void:
	animation_tree.active = true
	add_to_group("player")
	
#MOVIMIENTO
func tomar():
	for body in area.get_overlapping_bodies():
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
	
	velocity.x = move_toward(velocity.x,speed * move_input, aceleration * delta)
	
	move_and_slide()
	
	#Tomar y dejar la linterna
	if Input.is_action_just_pressed("lantern"):
		if tomar():
			conlinterna = true
			playback.travel("lantern")
	
	if Input.is_action_just_pressed("drop"):
		if conlinterna:
			conlinterna = false
			playback.travel("drop")
			playback.travel("idle")
		
	#Prender la linterna
	if Input.is_action_pressed("light") and conlinterna:
		rayo.prender_linterna()
	else:
		rayo.apagar_linterna()
	
	
		
	### ANIMACIONES	###
	
	if move_input != 0:
		pivote.scale.x = sign_Move_input
		
	preload ("res://sprites/Flashlight_wide_range_sprite_sheet.png")
		


		
		
