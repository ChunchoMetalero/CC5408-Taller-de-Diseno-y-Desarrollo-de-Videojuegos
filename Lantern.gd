extends StaticBody2D

@onready var linea: Line2D = Line2D.new() 

var angule: float = PI/3
var origen: Vector2 = Vector2(0,0)
var target_pos = origen + Vector2(1000,0)


func _ready() -> void:
	linea.add_point(origen)
	linea.add_point(origen)
	add_child(linea)  # Agregar la línea como un hijo del nodo StaticBody2D
	linea.default_color = Color(1, 0, 0)  # Color rojo
	linea.width = 2.0  # Ancho de línea
	

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("light"):
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(origen+position, target_pos+position)
		var result = space_state.intersect_ray(query)
		if result:
			print("Hit at point: ", result.position)
			linea.points[1] = result.position - position
		else:
			linea.points[1] = target_pos
	else:
		linea.points[1] = origen
		
			
	
