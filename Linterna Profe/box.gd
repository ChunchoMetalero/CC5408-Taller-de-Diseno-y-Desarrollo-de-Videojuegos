class_name Box
extends StaticBody2D

@onready var vertices: Node2D = $Vertices
@onready var test_line_a: Line2D = $TestLineA
@onready var test_line_b: Line2D = $TestLineB
var shadow_enabled: bool

func _ready() -> void:
	test_line_a.top_level = true
	test_line_b.top_level = true
	shadow_enabled = false


func get_vertices() -> Array[Vector2]:
	var result: Array[Vector2]
	result.assign(vertices.get_children().map(func(v: Marker2D): return v.global_position))
	return result

func create_collision(center: Vector2, vertex_a: Vector2, vertex_b: Vector2,segmentos: Array) -> void:
	test_line_a.clear_points()	
	var direction_A = center.direction_to(vertex_a).normalized()
	var duplex_A = get_length_shadow(vertex_a, direction_A ,segmentos,"Sup")
	test_line_a.add_point(duplex_A[0])
	test_line_a.add_point(duplex_A[1])
	test_line_b.clear_points()
	var direction_B = center.direction_to(vertex_b).normalized()
	var duplex_B = get_length_shadow(vertex_b, direction_B ,segmentos,"Bot")
	test_line_b.add_point(duplex_B[0])
	test_line_b.add_point(duplex_B[1])
	
	
func get_length_shadow(from_to: Vector2, direction: Vector2,segmentos:Array,tipo:String):
	var vertices: Array[Vector2] = []
	for segment in segmentos:
		var start_segment = segment[0]
		var end_segment = segment[1]
		var to_a = from_to + direction * 200
		var intersect = Geometry2D.segment_intersects_segment(from_to,to_a,start_segment,end_segment)
		if (intersect != null):
			vertices.append(from_to)
			vertices.append(intersect)
			return vertices
	if tipo == "Bot":
		direction = direction.rotated(-PI/2)
		for segment in segmentos:
			var start_segment = segment[0]
			var end_segment = segment[1]
			var to_a = from_to + direction * 50
			var intersect = Geometry2D.segment_intersects_segment(from_to,to_a,start_segment,end_segment)
			if (intersect != null):
				var result = [intersect,start_segment]
				return result
	if tipo == "Sup":
		direction = direction.rotated(PI/2)
		for segment in segmentos:
			var start_segment = segment[0]
			var end_segment = segment[1]
			var to_a = from_to + direction * 50
			var intersect = Geometry2D.segment_intersects_segment(from_to,to_a,start_segment,end_segment)
			if (intersect != null):
				var result = [intersect,end_segment]
				return result
	var result = [from_to,from_to]
	return result
			
	
	
func delete_collision() ->void:
	test_line_a.clear_points()
	test_line_b.clear_points()
