class_name PickLantern
extends RigidBody2D

@onready var lantern: PointLight2D = $Pivote/Lantern

var current_PickLantern = null

var active: bool
	

func pick(new_parent: Node2D, new_pos: Vector2):
	collision_layer = 0
	collision_mask = 0
	_update_parent_and_pos(new_parent, new_pos)
	


func drop(new_parent: Node2D, new_pos: Vector2):
	collision_layer = 1
	collision_mask = 1
	_update_parent_and_pos(new_parent, new_pos)
	
	
	
func _update_parent_and_pos(new_parent: Node2D, new_pos: Vector2):
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = new_pos
	
func encender():
	print("Señal")
	if lantern.is_physics_processing():#Apagar
		print("Apagar")
		lantern.set_physics_process(false)
		lantern.borrar_collision()
	else:#Encender
		print("Encender")
		lantern.set_physics_process(true)
