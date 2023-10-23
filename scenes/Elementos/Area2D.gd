extends Area2D
@onready var marker_2d: Marker2D = $Marker2D

func _ready():
	var space_state = get_world_2d().direct_space_state
	var from_position = global_position
	var to_position = marker_2d.global_position
	var query = PhysicsRayQueryParameters2D.create(from_position, to_position)
	var result = space_state.intersect_ray(query)

	if result:
		# Hubo una colisión
		var collision_point = result.position
		var collided_object = result.collider
		print("Colisión con:", collided_object, " en posición:", collision_point)
	else:
		# No hubo colisión
		print("No hubo colisión")
