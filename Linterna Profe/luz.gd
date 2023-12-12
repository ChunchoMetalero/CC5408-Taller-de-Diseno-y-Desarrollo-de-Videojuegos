extends PointLight2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var top_marker: Marker2D = $TopMarker
@onready var bottom_marker: Marker2D = $BottomMarker

#Test zone
@onready var debug_line: Line2D = $DebugLine

var boxes: Array[Box]
var perimeter_segments = []
var polygon_local = []
var collision_layer_temporal = 3
const TOLERANCE = 0.1
var error_Vector = Vector2(-9999999,-9999999)

func _ready() -> void:
	set_physics_process(false)
	''' Conexión y desconexión del area con la escena'''
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	
	''' Calculo de segementos del la luz '''
	calcular_polygono()
	
	
func _on_body_entered(body: Node) -> void:
	if body is Box:
		boxes.append(body)
		print("Dentro")

func _on_body_exited(body: Node) -> void:
	if body is Box:
		print("Fuera")
		boxes.erase(body)
		body.delete_collision()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Imprimir"):
		print(boxes)
		
func _physics_process(delta: float) -> void:
	
	for box in boxes:
		var vertices = box.get_vertices()
		
		''' CASOS BORDE '''
		
		''' La caja está tapada por otro objeto.'''
		var non_occluded_vertices: Array[Vector2] = []
		var space_state = get_world_2d().direct_space_state
		var other_boxes_rids = boxes.filter(func(v) : return v != box).map(func(v): return v.get_rid())
		# get not occluded vertices
		for vertex in vertices:
			var query = PhysicsRayQueryParameters2D.create(global_position, vertex)
			query.exclude = other_boxes_rids
			query.collision_mask = 4
			var result = space_state.intersect_ray(query)
			#print(result.collider.name)
			if not result or (result.position - vertex).length_squared() < TOLERANCE:
				non_occluded_vertices.push_back(vertex)
		# Si hay menos de 1 vertice tapado no se hace una sombra
		if non_occluded_vertices.size() < 1:
			#print("CCCC")
			box.delete_collision()
			continue
		'''  --------------------------------- '''	
		
		''' Cambio sistema de cordenados. Detección top and bottom '''
		var x_axis = global_position.direction_to(box.global_position)
		var y_axis = x_axis.rotated(PI/2)
		var t = Transform2D(x_axis, y_axis, box.global_position)
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
		
		
		var intersect_top
		var intersect_bottom
		if top_vertex and bottom_vertex:
			''' La caja no esta completamente dentro del area. '''
			var vertices_fuera: Array[Vector2] = []
			for vertex in vertices:
				calcular_polygono()
				var estado_vertice = Geometry2D.is_point_in_polygon(vertex,polygon_local)			
				if not estado_vertice:
					vertices_fuera.append(vertex)
			if vertices_fuera.size() != 0:
				if top_vertex in vertices_fuera and bottom_vertex in vertices_fuera:
					#print("BBBB")
					box.delete_collision()
					continue
				if top_vertex in vertices_fuera:
					#print("tuki")
					top_vertex = get_intersection_raycast(box,top_marker.position)
					intersect_top = to_global(top_marker.position)
				if bottom_vertex in vertices_fuera:
					#print("traka")
					bottom_vertex = get_intersection_raycast(box,bottom_marker.position) 
					intersect_bottom = to_global(bottom_marker.position)
				'''  --------------------------------- '''
				''' Top/bottom vertex demasiado encima del perimetro del area'''
				if bottom_vertex == error_Vector or top_vertex == error_Vector:
					#print("AAAAAAA")
					box.delete_collision()
					continue
					
			'''  --------------------------------- '''
			''' La caja es una caja ideal '''
			if not intersect_top:
				intersect_top = get_intersection_polygon(top_vertex,global_position.direction_to(top_vertex).normalized())
			if not intersect_bottom:
				intersect_bottom = get_intersection_polygon(bottom_vertex, global_position.direction_to(bottom_vertex).normalized())
			#print("XXXXXXXXXXXXXXXXXXXXX")
			box.create_collision(global_position,top_vertex,intersect_top,bottom_vertex,intersect_bottom )
		
func get_intersection_polygon(vertice:Vector2,direction:Vector2) -> Vector2:
	for segment in perimeter_segments:
		var start_segment = segment[0]
		var end_segment = segment[1]
		var to_a = vertice + direction * 2000
		var intersect = Geometry2D.segment_intersects_segment(vertice,to_a,start_segment,end_segment)
		if (intersect != null):
			return intersect
	return vertice
		
func get_intersection_raycast(body:Box, from_to: Vector2)-> Vector2:
	var other_boxes_rids = boxes.filter(func(v) : return v != body).map(func(v): return v.get_rid())
	var space_state = get_world_2d().direct_space_state
	debug_line.clear_points()
	debug_line.add_point(from_to)
	#debug_line.add_point(to_local(global_position))
	var query = PhysicsRayQueryParameters2D.create(to_global(from_to),global_position)
	query.set_collide_with_areas(false)
	query.exclude = other_boxes_rids
	query.collision_mask = 4
	var result = space_state.intersect_ray(query)
	if result:
		#print(result)
		if result.position.x <=  polygon_local[0].x:
			return error_Vector
		#print(result)
		#print(from_to,result.position)
		#debug_line.add_point(result.position)
		return result.position
	#print("AAAAAA")
	return error_Vector

func borrar_collision():
	for box in boxes:
		box.delete_collision()
		
func calcular_polygono():
	perimeter_segments = []
	polygon_local = []
	var paquete_vertices = collision_polygon_2d.get_polygon()
	var num_segmentos = paquete_vertices.size()
	for i in range(num_segmentos):
		var point_a = to_global(paquete_vertices[i])
		polygon_local.append(point_a)
		var point_b
		if i == num_segmentos - 1:
			point_b = to_global(paquete_vertices[0])
		else:
			point_b = to_global(paquete_vertices[i+1])
		perimeter_segments.append([point_a, point_b])
	
	
