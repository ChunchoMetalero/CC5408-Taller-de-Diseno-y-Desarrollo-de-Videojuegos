extends StaticBody2D

@onready var lineas: Array = []  # Arreglo para almacenar las líneas 
@onready var angulos: Array = []  # Arreglo para almacenar los ángulos

var num_rayos: int = 1000
var angulo_inicial: float = -PI/6  # Ángulo inicial de -30 grados
var angulo_final: float = PI/6  # Ángulo final de 30 grados
var origen: Vector2 = Vector2(0, 0)
var distancia_maxima: float = 1000.0  # Distancia máxima del raycast


func _ready() -> void:
	var angulo_incremento = (angulo_final - angulo_inicial) / (num_rayos - 1)
	for i in range(num_rayos):
		#ANGULOS
		var angulo = angulo_inicial + i * angulo_incremento
		angulos.append(angulo)
		
		#LINEAS
		var linea = Line2D.new()
		lineas.append(linea)  # Agregar la línea al arreglo
		add_child(linea)
		linea.default_color = Color(1, 0, 0)  # Color rojo
		linea.width = 1.0  # Ancho de línea
		linea.add_point(origen)
		linea.add_point(origen + Vector2(distancia_maxima, 0))
	

func _physics_process(delta: float) -> void:
	var espacio = get_world_2d().direct_space_state
	if Input.is_action_pressed("light"):
		for i in range(num_rayos):
			var angulo = angulos[i]
			var target = Vector2(distancia_maxima *cos(angulo), distancia_maxima *sin(angulo))
			var query = PhysicsRayQueryParameters2D.create(origen+position,target+position)
			var result = espacio.intersect_ray(query)

			if result:
				lineas[i].points[1] = result.position - position
			else:
				lineas[i].points[1] = target
	else:
		for linea in lineas:
			linea.points[1] = origen
		
	if Input.is_action_just_pressed("left"):
		for i in range(3):
			print(i)
