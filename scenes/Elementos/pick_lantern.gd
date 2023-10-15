class_name Pickable
extends RigidBody2D


func pick(new_parent: Node2D, new_pos: Vector2):
	process_mode = Node.PROCESS_MODE_DISABLED
	_update_parent_and_pos(new_parent, new_pos)

	

func drop(new_parent: Node2D, new_pos: Vector2):
	process_mode = Node.PROCESS_MODE_INHERIT
	_update_parent_and_pos(new_parent, new_pos)


func _update_parent_and_pos(new_parent: Node2D, new_pos: Vector2):
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = new_pos
