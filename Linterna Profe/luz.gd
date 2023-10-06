extends PointLight2D


@onready var debug_line: Line2D = $DebugLine

const TOLERANCE = 0.1
@onready var area_2d: Area2D = $Area2D
var boxes: Array[Box]

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	debug_line.clear_points()
	
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
			continue
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
			box.create_collision(global_position, top_vertex, bottom_vertex)
#			debug_line.add_point(top_vertex - global_position)
#			debug_line.add_point(bottom_vertex - global_position)
				
		
		

func _on_body_entered(body: Node) -> void:
	var box = body as Box
	if box:
		boxes.push_back(box)

func _on_body_exited(body: Node) -> void:
	boxes.erase(body)
