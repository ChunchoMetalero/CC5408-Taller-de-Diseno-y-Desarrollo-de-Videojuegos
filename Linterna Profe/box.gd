class_name Box
extends StaticBody2D


@onready var vertices: Node2D = $Vertices

@onready var test_line_a: Line2D = $TestLineA
@onready var test_line_b: Line2D = $TestLineB

func _ready() -> void:
	test_line_a.top_level = true
	test_line_b.top_level = true


func get_vertices() -> Array[Vector2]:
	var result: Array[Vector2]
	result.assign(vertices.get_children().map(func(v: Marker2D): return v.global_position))
	return result

func create_collision(center: Vector2, vertex_a: Vector2, vertex_b: Vector2) -> void:
	test_line_a.clear_points()
	test_line_a.add_point(vertex_a)
	test_line_a.add_point(test_line_a.points[0] + center.direction_to(vertex_a) * 50)
	test_line_b.clear_points()
	test_line_b.add_point(vertex_b)
	test_line_b.add_point(test_line_b.points[0] + center.direction_to(vertex_b) * 50)
