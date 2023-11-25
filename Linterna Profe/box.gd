class_name Box
extends AnimatableBody2D

@onready var test_line_a: Line2D = $TestLineA
@onready var test_line_b: Line2D = $TestLineB
@onready var vertices: Node2D = $Vertices

func delete_collision() -> void:
	test_line_a.clear_points()
	test_line_b.clear_points()

func get_vertices() -> Array[Vector2]:
	var result: Array[Vector2]
	result.assign(vertices.get_children().map(func(v: Marker2D): return v.global_position))
	return result
	
func create_collision(center: Vector2, from_to_a: Vector2, to_a: Vector2, from_to_b: Vector2, to_b : Vector2) -> void:
	test_line_a.clear_points()
	test_line_b.clear_points()
	test_line_a.add_point(to_local(from_to_a))
	test_line_a.add_point(to_local(to_a))
	test_line_b.add_point(to_local(from_to_b))
	test_line_b.add_point(to_local(to_b))
	
