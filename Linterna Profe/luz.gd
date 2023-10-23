extends PointLight2D


@onready var area_2d: Area2D = $Area2D
@onready var collision_area: CollisionPolygon2D = $Area2D/CollisionPolygon2D

var boxes: Array[Box]
var perimeter_segments
const TOLERANCE = 0.1


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	var paquete_vertices = collision_area.get_polygon()
	var num_segmentos = paquete_vertices.size()
	perimeter_segments = []
	for i in range(num_segmentos):
		var point_a = paquete_vertices[i] + global_position
		point_a = point_a
		var point_b
		if i == num_segmentos - 1:
			point_b = paquete_vertices[0] + global_position
		else:
			point_b = paquete_vertices[i+1] + global_position
		point_b = point_b
		perimeter_segments.append([point_a, point_b])
		


func _physics_process(delta: float) -> void:	
	for box in boxes:
		var vertices = box.get_vertices()
		var non_occluded_vertices: Array[Vector2] = []
		var space_state = get_world_2d().direct_space_state
		var other_boxes_rids = boxes.filter(func(v) : return v != box).map(func(v): return v.get_rid())
		# get not occluded vertices
		for vertex in vertices:
			var query = PhysicsRayQueryParameters2D.create(global_position, vertex)
			query.exclude = other_boxes_rids
			var result = space_state.intersect_ray(query)
			if not result or (result.position - vertex).length_squared() < TOLERANCE:
				non_occluded_vertices.push_back(vertex)
		# change cordinate system
		var x_axis = global_position.direction_to(box.global_position)
		var y_axis = x_axis.rotated(PI/2)
		var t = Transform2D(x_axis, y_axis, box.global_position)
		if non_occluded_vertices.size() < 2:
			box.delete_collision()
		var top_vertex_ty = 0
		var bottom_vertex_ty = 0
		var top_vertex
		var bottom_vertex
#		for vertex in non_occluded_vertices:
		for vertex in vertices:
			var t_position = t.basis_xform_inv(vertex - t.origin)
			if(t_position.y < top_vertex_ty):
				top_vertex_ty = t_position.y
				top_vertex = vertex
			if(t_position.y > bottom_vertex_ty):
				bottom_vertex_ty = t_position.y
				bottom_vertex = vertex
		if top_vertex and bottom_vertex:
			box.create_collision(global_position, top_vertex, bottom_vertex,perimeter_segments)

				
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Imprimir"):
		print(boxes)

func _on_body_entered(body: Node) -> void:
	if body is Box:
		boxes.append(body)
		body.shadow_enabled = true
		print("AAAA")

func _on_body_exited(body: Node) -> void:
	if body is Box:
		print("BBB")
		boxes.erase(body)
		body.shadow_enabled = false
		body.delete_collision()
