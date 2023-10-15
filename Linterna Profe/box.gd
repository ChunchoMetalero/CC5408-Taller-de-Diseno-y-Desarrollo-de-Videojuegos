class_name Box
extends StaticBody2D


@onready var vertices: Node2D = $Vertices
@onready var box: StaticBody2D = $"."

@onready var test_line_a: Line2D = $TestLineA
@onready var test_line_b: Line2D = $TestLineB
@onready var colision_sombra: CollisionPolygon2D = $Sombra/ColisionSombra
@onready var sombra_visible: Polygon2D = $Sombra/SombraVisible

func _ready() -> void:
	test_line_a.top_level = true
	test_line_b.top_level = true


func get_vertices() -> Array[Vector2]:
	var result: Array[Vector2]
	result.assign(vertices.get_children().map(func(v: Marker2D): return v.global_position))
	return result

func create_collision(center: Vector2, vertex_a: Vector2, vertex_b: Vector2) -> void:
	var center_local = box.to_local(center)
	var vertex_a_local = box.to_local(vertex_a)
	var vertex_b_local = box.to_local(vertex_b)
	var vertices_detectados = [vertex_a_local,vertex_b_local]
	var paquete_vertices = PackedVector2Array()
	paquete_vertices.append(vertex_a_local)
	var largo_luz = 256
	for vertice in vertices_detectados:
		var direccion = vertice - center_local
		var distancia = direccion.length()
		direccion = direccion.normalized()
		var puntoProyectado = vertice - direccion * (255 - distancia)# Proyecta siempre a una distancia de 255
		paquete_vertices.append(puntoProyectado)
	paquete_vertices.append(vertex_b_local)
	colision_sombra.polygon = paquete_vertices
	sombra_visible.polygon = paquete_vertices
	
