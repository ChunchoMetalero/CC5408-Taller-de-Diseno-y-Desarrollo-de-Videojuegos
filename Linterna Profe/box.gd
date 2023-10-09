class_name Box
extends StaticBody2D


@onready var vertices: Node2D = $Vertices

@onready var test_line_a: Line2D = $TestLineA
@onready var test_line_b: Line2D = $TestLineB
@onready var colision_sombra: CollisionPolygon2D = $Sombra/ColisionSombra

func _ready() -> void:
	test_line_a.top_level = true
	test_line_b.top_level = true


func get_vertices() -> Array[Vector2]:
	var result: Array[Vector2]
	result.assign(vertices.get_children().map(func(v: Marker2D): return v.global_position))
	return result

func create_collision(center: Vector2, vertex_a: Vector2, vertex_b: Vector2) -> void:
	var vertices_detectados = [vertex_a,vertex_b]
	var paquete_vertices = PackedVector2Array()
	paquete_vertices.append(vertex_a)
	var largo_luz = 256
	for vertice in vertices_detectados:
		var angulo = atan(vertice.y/vertice.x)		
		var u = (cos(angulo) * largo_luz) + global_position.x
		var w = (sin(angulo) * largo_luz) + global_position.y
		paquete_vertices.append(Vector2(u,w))
	paquete_vertices.append(vertex_b)
	colision_sombra.polygon = paquete_vertices
	
