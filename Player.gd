extends CharacterBody2D

var speed = 250
var gravity = 300
var jump_speed = 250
var aceleration = 10000

@onready var anim = $AnimationPlayer

func _physics_process(delta):
	var move_input = Input.get_axis("left","right")
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
	
	velocity.x = move_toward(velocity.x,speed * move_input, aceleration * delta)
	
	move_and_slide()
		
